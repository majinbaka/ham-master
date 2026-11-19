import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import '../application/profile_card_controller.dart';
import '../domain/profile_card.dart';
import 'profile_card_catalog.dart';
import 'profile_card_editor.dart';
import 'profile_journal.dart';
import 'profile_showcase_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({required this.onNavigate, super.key});

  final ValueChanged<String> onNavigate;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _cardKey = GlobalKey();
  final _backdropKey = GlobalKey();
  final _scrollController = ScrollController();
  var _sharing = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileCardProvider);
    return MenuShell(
      title: 'Hồ sơ',
      scrollChild: false,
      showPlayerHud: false,
      headerActions: profile.hasValue ? _actions(profile.requireValue) : null,
      selected: 'profile',
      notice: null,
      onNavigate: widget.onNavigate,
      backdrop: RepaintBoundary(
        key: _backdropKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: PixelUiColors.outline),
            (profile.value?.background ?? ProfileBackground.village).artwork,
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    PixelUiColors.outline.withValues(alpha: .82),
                    PixelUiColors.outline.withValues(alpha: .18),
                    PixelUiColors.outline.withValues(alpha: .82),
                  ],
                  stops: [0, .37, 1],
                ),
              ),
            ),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          key: const ValueKey('menu-content'),
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: profile.when(
                  data: (card) => RepaintBoundary(
                    key: _cardKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ProfileShowcaseCard(card: card),
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Đang tải thẻ',
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: MenuPanel(
                      light: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          const Text('Không mở được thẻ hồ sơ.'),
                          MenuButton(
                            label: 'Thử lại',
                            onPressed: () =>
                                ref.invalidate(profileCardProvider),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              MenuButton(
                label: 'Mở danh sách yêu thú',
                icon: PixelIconKind.beasts,
                showLabel: true,
                onPressed: () => widget.onNavigate('beasts'),
              ),
              ProfileJournal(onNavigate: widget.onNavigate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actions(ProfileCard card) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 4,
    children: [
      IconButton(
        tooltip: 'Chỉnh sửa thẻ',
        onPressed: _sharing ? null : () => _edit(card),
        icon: const Icon(Icons.edit_outlined),
      ),
      Builder(
        builder: (buttonContext) => IconButton(
          tooltip: _sharing ? 'Đang tạo ảnh…' : 'Chia sẻ ảnh',
          onPressed: _sharing ? null : () => _share(buttonContext, card),
          icon: const Icon(Icons.share_outlined),
        ),
      ),
    ],
  );

  void _edit(ProfileCard card) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProfileCardEditor(
        card: card,
        onSave: ref.read(profileCardProvider.notifier).saveEdits,
      ),
    );
  }

  Future<void> _share(BuildContext buttonContext, ProfileCard card) async {
    final button = buttonContext.findRenderObject()! as RenderBox;
    final origin = button.localToGlobal(Offset.zero) & button.size;
    setState(() => _sharing = true);
    try {
      if (_scrollController.hasClients && _scrollController.offset > 0) {
        _scrollController.jumpTo(0);
        await WidgetsBinding.instance.endOfFrame;
        if (!mounted) return;
      }
      final image = await _captureCard();
      final bytes = await _encodePng(image);
      if (!mounted) return;
      final filename = 'pixel-rpg-${card.friendCode}.png';
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(bytes, mimeType: 'image/png', name: filename)],
          fileNameOverrides: [filename],
          sharePositionOrigin: origin,
        ),
      );
    } on Exception {
      _showMessage('Chưa chia sẻ được ảnh thẻ. Thử lại.');
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<ui.Image> _captureCard() async {
    final backdropBoundary =
        _backdropKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final cardBoundary =
        _cardKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    final [backdrop, card] = await Future.wait([
      backdropBoundary.toImage(),
      cardBoundary.toImage(pixelRatio: 3),
    ], cleanUp: (image) => image.dispose());
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final backdropSize = Size(
        backdrop.width.toDouble(),
        backdrop.height.toDouble(),
      );
      final cardSize = Size(card.width.toDouble(), card.height.toDouble());
      final fitted = applyBoxFit(BoxFit.cover, backdropSize, cardSize);
      canvas.drawImageRect(
        backdrop,
        Alignment.center.inscribe(fitted.source, Offset.zero & backdropSize),
        Offset.zero & cardSize,
        Paint(),
      );
      canvas.drawImage(card, Offset.zero, Paint());
      final picture = recorder.endRecording();
      try {
        return await picture.toImage(card.width, card.height);
      } finally {
        picture.dispose();
      }
    } finally {
      backdrop.dispose();
      card.dispose();
    }
  }

  Future<Uint8List> _encodePng(ui.Image image) async {
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) throw const FormatException('Unable to encode card');
      return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    } finally {
      image.dispose();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

import 'package:flutter/material.dart';

import '../../../app/presentation/game_spacing.dart';
import '../../../app/presentation/player_hud.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import '../../../app/presentation/village_backdrop.dart';
import '../../../app/presentation/traveler_portrait.dart';
import '../../../app/presentation/scaled_artwork.dart';
import '../../../app/presentation/sample_detail_dialog.dart';
import 'home_footer.dart';
import 'home_layout.dart';
import 'home_navigation.dart';
import 'home_overview.dart';
import 'home_reading_view.dart';

/// Fixed-proportion game HUD over a scene that expands with the viewport.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    this.onOpenQuests,
    this.onOpenSideQuests,
    this.onOpenDailyQuests,
    this.onOpenBattle,
    this.onNavigate,
    super.key,
  });

  final VoidCallback? onOpenQuests;
  final VoidCallback? onOpenSideQuests;
  final VoidCallback? onOpenDailyQuests;
  final VoidCallback? onOpenBattle;
  final ValueChanged<String>? onNavigate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dialogueKey = GlobalKey();
  HomeAction? _action;

  void _showDialogue(HomeAction action) {
    setState(() => _action = action);
    final dialogueContext = _dialogueKey.currentContext;
    if (dialogueContext == null ||
        Scrollable.maybeOf(dialogueContext) == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!dialogueContext.mounted) return;
      Scrollable.ensureVisible(
        dialogueContext,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final quests = HomeQuests(
      onOpen: widget.onOpenQuests,
      onOpenSide: widget.onOpenSideQuests,
    );
    final dialogue = HomeDialogue(key: _dialogueKey, action: _action);
    HomeActions actions(double scale) => HomeActions(
      scale: scale,
      onAction: _showDialogue,
      onOpenBattle: widget.onOpenBattle,
    );
    HomeUtilities utilities(double scale) => HomeUtilities(
      gap: GameSpacing.small * scale,
      onDailyQuests: widget.onOpenDailyQuests,
      onInformation: () => _showInformation(context),
    );
    if (MediaQuery.textScalerOf(context).scale(17) > 17 * 1.15) {
      final layout = HomeLayout(MediaQuery.sizeOf(context));
      return HomeReadingView(
        onNavigate: widget.onNavigate,
        quests: quests,
        dialogue: dialogue,
        utilities: SizedBox(height: 48, child: utilities(layout.scale)),
        actions: SizedBox(
          height: layout.actionHeight,
          child: actions(layout.scale),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final layout = HomeLayout(
              constraints.biggest,
              deviceShortSide: MediaQuery.sizeOf(context).shortestSide,
            );
            return Stack(
              children: [
                const Positioned.fill(child: VillageBackdrop()),
                _place(
                  'home-profile',
                  layout.profile,
                  layout.scale,
                  const PlayerHud(),
                ),
                _place(
                  'home-resources',
                  layout.resources,
                  layout.scale,
                  const ResourceHud(),
                ),
                _placeContent('home-quests', layout.quests, quests),
                _placeControls(
                  'home-utilities',
                  layout.utilities,
                  utilities(layout.scale),
                ),
                Positioned.fromRect(
                  rect: layout.character,
                  child: const TravelerPortrait(
                    key: ValueKey('character-placeholder'),
                  ),
                ),
                _placeContent('home-dialogue', layout.dialogue, dialogue),
                _placeControls(
                  'home-actions',
                  layout.actions,
                  actions(layout.scale),
                ),
                _placeControls(
                  'home-navigation',
                  layout.navigation,
                  HomeNavigation(onNavigate: widget.onNavigate),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _placeControls(String key, Rect rect, Widget child) =>
      Positioned.fromRect(
        rect: rect,
        child: SizedBox(key: ValueKey(key), child: child),
      );

  Widget _place(String key, Rect rect, double scale, Widget child) =>
      Positioned.fromRect(
        rect: rect,
        child: SizedBox(
          key: ValueKey(key),
          child: ScaledArtwork(
            scale: scale,
            size: Size(rect.width / scale, rect.height / scale),
            child: child,
          ),
        ),
      );

  Widget _placeContent(String key, Rect rect, Widget child) =>
      Positioned.fromRect(
        rect: rect,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(key: ValueKey(key), width: rect.width, child: child),
        ),
      );

  void _showInformation(BuildContext context) => showSampleDetail(
    context,
    'Chào mừng đến với Pixel RPG',
    'Cảnh làng và nhà lữ hành là hình minh họa tĩnh.\n\n'
        'Thanh dưới mở Cốt truyện, Nhiệm vụ, Cửa hàng, Hồ sơ và Cài đặt. '
        'Nói chuyện, Quan sát và Tìm kiếm cập nhật ô hội thoại. Nút Trận chiến mở đấu trường. '
        'Cụm tiện ích có Hộp thư và lối tắt nhiệm vụ hằng ngày.',
    icon: PixelIconKind.info,
    closeLabel: 'Đã hiểu',
  );
}

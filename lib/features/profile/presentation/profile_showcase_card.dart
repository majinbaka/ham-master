import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import '../../../app/theme/game_surface_style.dart';
import '../../../app/theme/game_typography.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import '../domain/profile_card.dart';
import 'profile_card_catalog.dart';

class ProfileShowcaseCard extends StatelessWidget {
  const ProfileShowcaseCard({required this.card, super.key});

  final ProfileCard card;

  @override
  Widget build(BuildContext context) => Material(
    color: PixelUiColors.paper,
    shape: GameSurfaceStyle.shape(color: PixelUiColors.amber),
    borderOnForeground: true,
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Cover(card: card),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(card.name, style: GameTypography.title),
                  if (card.title.isNotEmpty)
                    Text(
                      card.title,
                      style: GameTypography.label.copyWith(
                        color: PixelUiColors.coral,
                      ),
                    ),
                  if (card.bio.isNotEmpty) Text(card.bio),
                ],
              ),
              if (card.badges.isNotEmpty)
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    for (final badge in ProfileBadge.values.where(
                      card.badges.contains,
                    ))
                      _CardBadge(badge),
                  ],
                ),
              const _CardDivider(),
              _FriendCode(code: card.friendCode),
              if (card.showStats) ...[const _CardDivider(), const _Stats()],
            ],
          ),
        ),
      ],
    ),
  );
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: PixelUiColors.frameBorder);
}

class _Cover extends StatelessWidget {
  const _Cover({required this.card});

  final ProfileCard card;

  @override
  Widget build(BuildContext context) {
    final companion = profileCompanion(card.companion);
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = (constraints.maxWidth * .43).clamp(116.0, 212.0);
        final spriteSize = height * .66;
        return SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              card.background.artwork,
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, PixelUiColors.outline],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: spriteSize,
                        width: spriteSize * .6,
                        child: card.avatar.portrait,
                      ),
                      if (companion != null)
                        Semantics(
                          image: true,
                          label: companion.name,
                          child: companion.sprite.artwork(spriteSize),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardBadge extends StatelessWidget {
  const _CardBadge(this.badge);

  final ProfileBadge badge;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 4,
    children: [
      PixelIcon(badge.icon, size: 36),
      Flexible(child: Text(badge.label)),
    ],
  );
}

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 6,
    children: [
      Text('Chỉ số hành trình mẫu', style: GameTypography.panelTitle),
      Text('Cấp 12 · EXP 2.340 / 3.600 (65%)', style: GameTypography.caption),
      PixelProgress(value: .65, label: 'Kinh nghiệm mẫu'),
      MenuGrid(
        minItemWidth: 96,
        maxColumns: 3,
        children: [
          _Stat(PixelIconKind.beasts, 'Yêu thú', '28 / 150'),
          _Stat(PixelIconKind.compass, 'Khu vực', '3 / 8'),
          _Stat(PixelIconKind.coin, 'Huy hiệu', '5'),
        ],
      ),
    ],
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label, this.value);
  final PixelIconKind icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      PixelIcon(icon, size: 36),
      Text(label, textAlign: TextAlign.center),
      Text(value, textAlign: TextAlign.center, style: GameTypography.heading),
    ],
  );
}

class _FriendCode extends StatelessWidget {
  const _FriendCode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final qr = QrImageView(
        data: code,
        semanticsLabel: 'Mã QR kết bạn $code',
        version: QrVersions.auto,
        size: 99,
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
      );
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          const Text('Mã kết bạn', style: GameTypography.panelTitle),
          Text(code, style: GameTypography.label),
        ],
      );
      final wide =
          constraints.maxWidth >=
          107 + MediaQuery.textScalerOf(context).scale(190);
      return wide
          ? Row(
              spacing: 8,
              children: [
                Expanded(child: text),
                qr,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [text, qr],
            );
    },
  );
}

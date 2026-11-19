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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
      final wide = constraints.maxWidth >= 600 * textScale;
      final viewportHeight = MediaQuery.sizeOf(context).height;
      final artHeight = wide
          ? ((viewportHeight - 280) * .75).clamp(100.0, 440.0)
          : (viewportHeight * .30).clamp(132.0, 280.0);
      final portraits = SizedBox(
        height: artHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _Portraits(card: card, height: artHeight.clamp(0.0, 120.0)),
        ),
      );
      final info = _CardInformation(card: card);
      return wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Expanded(child: portraits),
                SizedBox(width: 316 * textScale, child: info),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [portraits, info],
            );
    },
  );
}

class _CardInformation extends StatelessWidget {
  const _CardInformation({required this.card});

  final ProfileCard card;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: PixelUiColors.outline.withValues(alpha: .82),
      shape: GameSurfaceStyle.shape(color: PixelUiColors.frameBorder),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: PixelUiColors.paper),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Semantics(
                  header: true,
                  child: Text(card.name, style: GameTypography.title),
                ),
                if (card.title.isNotEmpty)
                  Text(
                    card.title,
                    style: GameTypography.label.copyWith(
                      color: PixelUiColors.gold,
                    ),
                  ),
                if (card.bio.isNotEmpty) Text(card.bio),
              ],
            ),
            if (card.showStats) const _Stats(),
            _FriendCode(card: card),
          ],
        ),
      ),
    ),
  );
}

class _Portraits extends StatelessWidget {
  const _Portraits({required this.card, required this.height});

  final ProfileCard card;
  final double height;

  @override
  Widget build(BuildContext context) {
    final companion = profileCompanion(card.companion);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 16,
      children: [
        SizedBox(
          width: height * .6,
          height: height,
          child: card.avatar.portrait,
        ),
        if (companion != null)
          Semantics(
            image: true,
            label: companion.name,
            child: companion.sprite.artwork(height * 92 / 120),
          ),
      ],
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
      PixelIcon(badge.icon, size: 24),
      Flexible(child: Text(badge.label, style: GameTypography.caption)),
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
      Wrap(
        spacing: 8,
        runSpacing: 2,
        children: [
          Text('Yêu thú 28 / 150', style: GameTypography.caption),
          Text('Khu vực 3 / 8', style: GameTypography.caption),
          Text('Huy hiệu 5', style: GameTypography.caption),
        ],
      ),
    ],
  );
}

class _FriendCode extends StatelessWidget {
  const _FriendCode({required this.card});

  final ProfileCard card;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final qr = QrImageView(
        data: card.friendCode,
        semanticsLabel: 'Mã QR kết bạn ${card.friendCode}',
        version: QrVersions.auto,
        size: 92,
        padding: const EdgeInsets.all(14),
        backgroundColor: Colors.white,
      );
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          const Text('Mã kết bạn', style: GameTypography.panelTitle),
          Text(card.friendCode, style: GameTypography.label),
          if (card.badges.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 2,
              children: [
                for (final badge in ProfileBadge.values.where(
                  card.badges.contains,
                ))
                  _CardBadge(badge),
              ],
            ),
        ],
      );
      final wide =
          constraints.maxWidth >=
          100 + MediaQuery.textScalerOf(context).scale(168);
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

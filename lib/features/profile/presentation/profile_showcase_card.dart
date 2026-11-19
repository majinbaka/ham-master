import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/theme/game_surface_style.dart';
import '../../../app/theme/game_typography.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import '../../beasts/presentation/beast_preview_data.dart';
import '../domain/profile_card.dart';
import 'profile_card_catalog.dart';

class ProfileShowcaseCard extends StatelessWidget {
  const ProfileShowcaseCard({required this.card, super.key});

  final ProfileCard card;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 600;
      final info = FittedBox(
        fit: BoxFit.scaleDown,
        alignment: wide ? Alignment.centerRight : Alignment.bottomCenter,
        child: SizedBox(
          width: constraints.maxWidth.clamp(0.0, 360.0),
          child: _CardInformation(card: card),
        ),
      );
      final portraits = Align(
        alignment: wide ? Alignment.center : Alignment.bottomCenter,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _Portraits(card: card),
        ),
      );
      return wide
          ? Row(
              spacing: 8,
              children: [
                Expanded(child: portraits),
                SizedBox(width: 360, child: info),
              ],
            )
          : Column(
              spacing: 8,
              children: [
                Expanded(child: portraits),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * .85,
                  ),
                  child: info,
                ),
              ],
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
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    card.name,
                    style: GameTypography.title.copyWith(
                      color: PixelUiColors.paper,
                    ),
                  ),
                ),
                Text(
                  '${BeastPreview.owned.length} yêu thú',
                  style: GameTypography.label.copyWith(
                    color: PixelUiColors.gold,
                  ),
                ),
              ],
            ),
          ),
          QrImageView(
            data: card.friendCode,
            semanticsLabel: 'Mã QR kết bạn ${card.friendCode}',
            version: QrVersions.auto,
            size: 88,
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    ),
  );
}

class _Portraits extends StatelessWidget {
  const _Portraits({required this.card});

  final ProfileCard card;

  @override
  Widget build(BuildContext context) {
    final companion = profileCompanion(card.companion);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 16,
      children: [
        SizedBox(width: 72, height: 120, child: card.avatar.portrait),
        if (companion != null)
          Semantics(
            image: true,
            label: companion.name,
            child: companion.sprite.artwork(92),
          ),
      ],
    );
  }
}

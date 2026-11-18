import 'package:flutter/material.dart';

import 'traveler_portrait.dart';
import 'game_spacing.dart';
import 'pixel/pixel_frame.dart';
import 'pixel/pixel_progress.dart';

/// Character portrait, level and EXP in a fixed artwork slot.
class PlayerHud extends StatelessWidget {
  const PlayerHud({super.key});

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: const EdgeInsets.all(GameSpacing.small),
    child: Row(
      children: [
        const PixelFrame(
          skin: PixelFrameSkin.cool,
          padding: EdgeInsets.all(GameSpacing.small),
          child: SizedBox(
            width: 58,
            height: 66,
            child: Center(
              child: SizedBox(width: 40, height: 66, child: TravelerPortrait()),
            ),
          ),
        ),
        const SizedBox(width: GameSpacing.small),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
                child: PixelLabel(
                  'Cấp —   Nhà lữ hành',
                  fontSize: 36,
                  alignment: Alignment.centerLeft,
                ),
              ),
              const SizedBox(height: GameSpacing.small),
              Row(
                children: [
                  const SizedBox(
                    width: 54,
                    height: 24,
                    child: PixelLabel('EXP', fontSize: 30),
                  ),
                  const SizedBox(width: GameSpacing.small),
                  Expanded(
                    child: PixelProgress(
                      value: null,
                      label: 'Kinh nghiệm chưa có',
                      height: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

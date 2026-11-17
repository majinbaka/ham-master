import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';
import 'game_spacing.dart';
import 'pixel/pixel_frame.dart';
import 'pixel/pixel_icon.dart';
import 'pixel/pixel_progress.dart';

/// Fixed 440 × 120 design units; anchored independently of resource counters.
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
            child: ColoredBox(color: PixelUiColors.gold),
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

/// Two counters above one centered counter, at every viewport orientation.
class ResourceHud extends StatelessWidget {
  const ResourceHud({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Row(
        children: [
          Expanded(
            child: _Counter(icon: PixelIconKind.coin, label: 'Vàng'),
          ),
          SizedBox(width: GameSpacing.small),
          Expanded(
            child: _Counter(icon: PixelIconKind.gem, label: 'Ngọc'),
          ),
        ],
      ),
      const SizedBox(height: GameSpacing.gap),
      const SizedBox(
        width: 250,
        child: _Counter(icon: PixelIconKind.energy, label: 'Năng lượng'),
      ),
    ],
  );
}

class _Counter extends StatelessWidget {
  const _Counter({required this.icon, required this.label});

  final PixelIconKind icon;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: chưa có',
    excludeSemantics: true,
    child: SizedBox(
      height: 50,
      child: PixelFrame(
        skin: PixelFrameSkin.cool,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PixelIcon(icon, size: 40),
            const SizedBox(width: GameSpacing.small),
            const PixelLabel('—', fontSize: 36),
          ],
        ),
      ),
    ),
  );
}

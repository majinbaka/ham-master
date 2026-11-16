import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'home_spacing.dart';
import 'pixel_frame.dart';
import 'pixel_icon.dart';

/// Fixed 440 × 120 design units; anchored independently of resource counters.
class HomeProfile extends StatelessWidget {
  const HomeProfile({super.key});

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: const EdgeInsets.all(HomeSpacing.small),
    child: Row(
      children: [
        const PixelFrame(
          skin: PixelFrameSkin.cool,
          padding: EdgeInsets.all(HomeSpacing.small),
          child: SizedBox(
            width: 58,
            height: 66,
            child: ColoredBox(color: PixelUiColors.gold),
          ),
        ),
        const SizedBox(width: HomeSpacing.small),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
                child: PixelLabel(
                  'Cấp —   Nhà lữ hành',
                  fontSize: 27,
                  alignment: Alignment.centerLeft,
                ),
              ),
              const SizedBox(height: HomeSpacing.small),
              Row(
                children: [
                  const SizedBox(
                    width: 54,
                    height: 24,
                    child: PixelLabel('EXP', fontSize: 24),
                  ),
                  const SizedBox(width: HomeSpacing.small),
                  Expanded(
                    child: Semantics(
                      label: 'Kinh nghiệm chưa có',
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: PixelUiColors.outline,
                          border: Border.all(
                            color: PixelUiColors.cream,
                            width: 2,
                          ),
                        ),
                      ),
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
class HomeResources extends StatelessWidget {
  const HomeResources({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Row(
        children: [
          Expanded(
            child: _Counter(icon: PixelIconKind.coin, label: 'Vàng'),
          ),
          SizedBox(width: HomeSpacing.small),
          Expanded(
            child: _Counter(icon: PixelIconKind.gem, label: 'Ngọc'),
          ),
        ],
      ),
      const SizedBox(height: HomeSpacing.gap),
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
            PixelIcon(icon, size: 32),
            const SizedBox(width: HomeSpacing.small),
            const PixelLabel('—', fontSize: 28),
          ],
        ),
      ),
    ),
  );
}

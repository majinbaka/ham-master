import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'pixel_frame.dart';

/// Fixed 470 × 118 design units; anchored independently of resource counters.
class HomeProfile extends StatelessWidget {
  const HomeProfile({super.key});

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        const PixelFrame(
          skin: PixelFrameSkin.cool,
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 58,
            height: 66,
            child: ColoredBox(color: PixelUiColors.gold),
          ),
        ),
        const SizedBox(width: 14),
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
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 54,
                    height: 24,
                    child: PixelLabel('EXP', fontSize: 24),
                  ),
                  const SizedBox(width: 8),
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
            child: _Counter(
              icon: Icons.toll,
              label: 'Vàng',
              color: PixelUiColors.gold,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _Counter(
              icon: Icons.diamond_outlined,
              label: 'Ngọc',
              color: PixelUiColors.cyan,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      const SizedBox(
        width: 250,
        child: _Counter(
          icon: Icons.bolt,
          label: 'Năng lượng',
          color: PixelUiColors.gold,
        ),
      ),
    ],
  );
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: chưa có',
    excludeSemantics: true,
    child: SizedBox(
      height: 50,
      child: PixelFrame(
        skin: PixelFrameSkin.cool,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            const Expanded(child: PixelLabel('—', fontSize: 28)),
          ],
        ),
      ),
    ),
  );
}

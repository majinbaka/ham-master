import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'home_spacing.dart';
import 'pixel_frame.dart';
import 'pixel_icon.dart';

class HomeDialogue extends StatelessWidget {
  const HomeDialogue({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        top: 30,
        child: PixelFrame(
          skin: PixelFrameSkin.paper,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 36,
                child: PixelLabel(
                  'Chào mừng, nhà lữ hành!',
                  fontSize: 31,
                  color: PixelUiColors.outline,
                  alignment: Alignment.centerLeft,
                ),
              ),
              SizedBox(height: HomeSpacing.small),
              SizedBox(
                height: 32,
                child: PixelLabel(
                  'Hành trình mới đang chờ bạn.',
                  fontSize: 28,
                  color: PixelUiColors.surface,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),
        ),
      ),
      const Positioned(
        left: 30,
        top: 0,
        width: 260,
        height: 54,
        child: PixelFrame(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: PixelLabel(
            'Pixel RPG',
            fontSize: 28,
            color: PixelUiColors.cream,
          ),
        ),
      ),
    ],
  );
}

/// Action placeholders preserve the three-button composition of the reference.
class HomeActions extends StatelessWidget {
  const HomeActions({super.key});

  @override
  Widget build(BuildContext context) => Row(
    spacing: HomeSpacing.gap,
    children: [
      for (final item in const [
        (PixelIconKind.talk, 'Nói chuyện'),
        (PixelIconKind.observe, 'Quan sát'),
        (PixelIconKind.search, 'Tìm kiếm'),
      ])
        Expanded(
          child: SizedBox(
            height: 120,
            child: Semantics(
              enabled: false,
              label: '${item.$2}, chưa mở',
              excludeSemantics: true,
              child: PixelFrame(
                padding: const EdgeInsets.all(HomeSpacing.small),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PixelIcon(item.$1, size: 40),
                      const SizedBox(height: HomeSpacing.small),
                      SizedBox(
                        height: 26,
                        child: PixelLabel(item.$2, fontSize: 27),
                      ),
                      const SizedBox(
                        height: 16,
                        child: PixelLabel(
                          'Chưa mở',
                          fontSize: 15,
                          color: PixelUiColors.cool,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

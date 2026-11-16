import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'pixel_frame.dart';

class HomeDialogue extends StatelessWidget {
  const HomeDialogue({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        top: 32,
        child: PixelFrame(
          skin: PixelFrameSkin.paper,
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
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
              SizedBox(height: 8),
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
        left: 32,
        top: 0,
        width: 260,
        height: 54,
        child: PixelFrame(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      for (final item in const [
        (Icons.chat_bubble_outline, 'Nói chuyện'),
        (Icons.search, 'Quan sát'),
        (Icons.travel_explore, 'Tìm kiếm'),
      ])
        SizedBox(
          width: 260,
          height: 124,
          child: Semantics(
            enabled: false,
            label: '${item.$2}, chưa mở',
            excludeSemantics: true,
            child: PixelFrame(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.$1, size: 42, color: PixelUiColors.cool),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 30,
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
    ],
  );
}

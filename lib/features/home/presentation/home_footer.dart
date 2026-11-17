import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import '../../../app/presentation/game_spacing.dart';
import '../../../app/presentation/menu_button.dart';
import '../../../app/presentation/pixel/pixel_frame.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

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
                height: 40,
                child: PixelLabel(
                  'Chào mừng, nhà lữ hành!',
                  fontSize: 40,
                  color: PixelUiColors.outline,
                  alignment: Alignment.centerLeft,
                ),
              ),
              SizedBox(height: GameSpacing.small),
              SizedBox(
                height: 36,
                child: PixelLabel(
                  'Hành trình mới đang chờ bạn.',
                  fontSize: 38,
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
            fontSize: 38,
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
    spacing: GameSpacing.gap,
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
              child: MenuButton(
                label: item.$2,
                icon: item.$1,
                artworkScale: 2,
                onPressed: null,
              ),
            ),
          ),
        ),
    ],
  );
}

import 'package:flutter/material.dart';

import '../../../app/presentation/game_spacing.dart';
import '../../../app/presentation/menu_button.dart';
import '../../../app/presentation/menu_panel.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

class HomeDialogue extends StatelessWidget {
  const HomeDialogue({super.key});

  @override
  Widget build(BuildContext context) => const MenuPanel(
    title: 'Pixel RPG',
    light: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text('Chào mừng, nhà lữ hành!'),
        Text('Hành trình mới đang chờ bạn.'),
      ],
    ),
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

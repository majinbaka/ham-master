import 'package:flutter/material.dart';

import '../../../app/presentation/game_spacing.dart';
import '../../../app/presentation/menu_button.dart';
import '../../../app/presentation/menu_panel.dart';
import '../../../app/presentation/pixel/pixel_frame_skin.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

enum HomeAction {
  talk(
    PixelIconKind.talk,
    PixelFrameSkin.gold,
    'Nói chuyện',
    'Người gác làng: Hãy ghé trại gần cổng làng.',
  ),
  observe(
    PixelIconKind.observe,
    PixelFrameSkin.cyan,
    'Quan sát',
    'Ánh đèn ven đường dẫn về phía cổng làng.',
  ),
  search(
    PixelIconKind.search,
    PixelFrameSkin.cool,
    'Tìm kiếm',
    'Chưa thấy vật phẩm quanh trại.',
  );

  const HomeAction(this.icon, this.skin, this.label, this.message);

  final PixelIconKind icon;
  final PixelFrameSkin skin;
  final String label;
  final String message;
}

class HomeDialogue extends StatelessWidget {
  const HomeDialogue({required this.action, super.key});

  final HomeAction? action;

  @override
  Widget build(BuildContext context) => MenuPanel(
    title: 'Pixel RPG',
    light: true,
    child: Semantics(
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          if (action case final interaction?)
            Text(interaction.message)
          else ...const [
            Text('Chào mừng, nhà lữ hành!'),
            Text('Hành trình mới đang chờ bạn.'),
          ],
        ],
      ),
    ),
  );
}

class HomeActions extends StatelessWidget {
  const HomeActions({
    required this.scale,
    required this.onAction,
    this.onOpenBattle,
    super.key,
  });

  final double scale;
  final ValueChanged<HomeAction> onAction;
  final VoidCallback? onOpenBattle;

  @override
  Widget build(BuildContext context) => Row(
    spacing: GameSpacing.gap * scale,
    children: [
      for (final action in HomeAction.values)
        Expanded(
          child: MenuButton(
            label: action.label,
            icon: action.icon,
            skin: action.skin,
            artworkScale: 2 * scale,
            onPressed: () => onAction(action),
          ),
        ),
      if (onOpenBattle != null)
        Expanded(
          child: MenuButton(
            label: 'Trận chiến',
            icon: PixelIconKind.battle,
            skin: PixelFrameSkin.selected,
            artworkScale: 2 * scale,
            onPressed: onOpenBattle,
          ),
        ),
    ],
  );
}

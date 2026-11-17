import 'package:flutter/material.dart';

import '../../../app/presentation/menu_panel.dart';
import '../../../app/presentation/game_spacing.dart';
import '../../../app/presentation/pixel/pixel_frame.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

/// Home and menus render copy at logical sizes, independently of artwork.
class HomeQuests extends StatelessWidget {
  const HomeQuests({this.onOpen, super.key});
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 8,
    children: [
      Tooltip(
        message: 'Mở Nhiệm vụ',
        child: Semantics(
          button: onOpen != null,
          label: onOpen == null ? null : 'Mở Nhiệm vụ',
          child: GestureDetector(
            onTap: onOpen,
            behavior: HitTestBehavior.opaque,
            child: MenuPanel(
              title: 'Nhiệm vụ chính',
              child: Text(onOpen == null ? 'Chưa có nhiệm vụ' : 'Xem nhiệm vụ'),
            ),
          ),
        ),
      ),
      const MenuPanel(
        title: 'Nhiệm vụ phụ',
        child: Text('Chưa có nhiệm vụ phụ'),
      ),
    ],
  );
}

class HomeMinimap extends StatelessWidget {
  const HomeMinimap({super.key});

  @override
  Widget build(BuildContext context) => MenuPanel(
    title: 'BẢN ĐỒ',
    child: SizedBox(
      height: 48,
      child: ColoredBox(
        color: Colors.black,
        child: Semantics(
          label: 'Bản đồ chưa mở',
          child: Center(child: PixelIcon(PixelIconKind.lock, size: 24)),
        ),
      ),
    ),
  );
}

class HomeUtilities extends StatelessWidget {
  const HomeUtilities({super.key});

  @override
  Widget build(BuildContext context) => Row(
    spacing: GameSpacing.small,
    children: [
      for (final icon in const [
        PixelIconKind.mail,
        PixelIconKind.tasks,
        PixelIconKind.info,
      ])
        Expanded(
          child: ExcludeSemantics(
            child: PixelFrame(
              skin: PixelFrameSkin.cool,
              padding: const EdgeInsets.all(GameSpacing.small),
              child: Center(child: PixelIcon(icon, size: 40)),
            ),
          ),
        ),
    ],
  );
}

import 'package:flutter/material.dart';

import '../../../app/presentation/beast_sprite.dart';
import '../../../app/presentation/pixel/pixel_frame.dart';
import '../../../app/theme/pixel_ui_colors.dart';

/// Illustrates the two sides of the encounter and the selected target.
class BattleArena extends StatelessWidget {
  const BattleArena({
    required this.onTarget,
    required this.targetSelected,
    super.key,
  });

  final VoidCallback? onTarget;
  final bool targetSelected;

  @override
  Widget build(BuildContext context) => PixelFrame(
    padding: EdgeInsets.zero,
    child: SizedBox(
      height: 232,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/scenes/forest-arena.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
              excludeFromSemantics: true,
            ),
            Align(
              alignment: const Alignment(.13, -.8),
              child: Tooltip(
                message: 'Chọn Sói Bóng Đêm làm mục tiêu',
                excludeFromSemantics: true,
                child: Semantics(
                  label: 'Chọn Sói Bóng Đêm làm mục tiêu',
                  button: true,
                  selected: targetSelected,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: onTarget,
                      child: Stack(
                        children: [
                          BeastSprite.shadowWolf.artwork(90),
                          if (targetSelected)
                            const Positioned(
                              top: 0,
                              right: 0,
                              child: Icon(
                                Icons.adjust,
                                color: PixelUiColors.paper,
                                shadows: [
                                  Shadow(
                                    color: PixelUiColors.coral,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment(.04, .03),
              child: Icon(
                Icons.keyboard_double_arrow_up,
                color: PixelUiColors.paper,
                shadows: [Shadow(color: PixelUiColors.amber, blurRadius: 5)],
                size: 38,
              ),
            ),
            Align(
              alignment: const Alignment(-.12, .84),
              child: BeastSprite.fireFoxBack.artwork(86),
            ),
          ],
        ),
      ),
    ),
  );
}

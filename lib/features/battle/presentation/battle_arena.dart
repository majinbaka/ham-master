import 'package:flutter/material.dart';

import '../../../app/presentation/battle_move.dart';
import '../../../app/presentation/beast_sprite.dart';
import '../../../app/presentation/pixel/pixel_frame.dart';
import '../../../app/presentation/pixel/pixel_progress.dart';
import '../../../app/theme/game_typography.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import '../../beasts/presentation/beast_preview_data.dart';

/// Places the fighters and their HP directly over the encounter artwork.
class BattleArena extends StatelessWidget {
  const BattleArena({
    required this.move,
    required this.cast,
    required this.showEffect,
    required this.onTarget,
    super.key,
  });

  final BattleMove move;
  final int cast;
  final bool showEffect;
  final VoidCallback onTarget;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Align(
        alignment: const Alignment(-.48, .62),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BeastSprite.fireFoxBack.artwork(96),
            _Health(hp: BeastPreview.fireFox.stats.$1),
          ],
        ),
      ),
      Align(
        alignment: const Alignment(.48, -.55),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Health(hp: BeastPreview.shadowWolf.stats.$1, enemy: true),
            Tooltip(
              message: 'Đánh đối thủ',
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTarget,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      BeastSprite.shadowWolf.artwork(104),
                      if (showEffect)
                        Semantics(
                          liveRegion: true,
                          label: '${move.label} trúng mục tiêu',
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey(cast),
                            tween: Tween(begin: 1, end: 0),
                            duration: MediaQuery.disableAnimationsOf(context)
                                ? Duration.zero
                                : const Duration(milliseconds: 650),
                            builder: (context, opacity, child) => Opacity(
                              opacity: MediaQuery.disableAnimationsOf(context)
                                  ? 1
                                  : opacity,
                              child: child,
                            ),
                            child: move.artwork,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Health extends StatelessWidget {
  const _Health({required this.hp, this.enemy = false});

  final int hp;
  final bool enemy;

  @override
  Widget build(BuildContext context) => Semantics(
    label: enemy ? 'Máu đối thủ' : 'Máu đồng đội',
    value: '$hp / $hp',
    excludeSemantics: true,
    child: PixelFrame(
      skin: enemy ? PixelFrameSkin.selected : PixelFrameSkin.cool,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          Text('HP $hp / $hp', style: GameTypography.caption),
          SizedBox(
            width: 80,
            child: PixelProgress(
              value: 1,
              height: 8,
              label: 'HP',
              fillColor: enemy ? PixelUiColors.coral : PixelUiColors.teal,
            ),
          ),
        ],
      ),
    ),
  );
}

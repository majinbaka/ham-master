import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/pixel/pixel_frame.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import '../../../app/presentation/village_backdrop.dart';
import '../../../app/theme/game_typography.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import 'beast_preview_data.dart';

class BeastDetail extends StatelessWidget {
  const BeastDetail({
    required this.beast,
    required this.onPrevious,
    required this.onNext,
    required this.favorite,
    required this.onFavorite,
    required this.onBattle,
    super.key,
  });

  final BeastPreview beast;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback onBattle;

  @override
  Widget build(BuildContext context) {
    final (hp, attack, defense, speed) = beast.stats;
    final owned = beast != BeastPreview.shadowWolf;
    return MenuPanel(
      title: beast.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          PixelFrame(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 138,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const VillageBackdrop(),
                    Center(child: beast.sprite.artwork(116)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        tooltip: 'Yêu thú trước',
                        onPressed: onPrevious,
                        icon: const Icon(Icons.chevron_left),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        tooltip: 'Yêu thú tiếp theo',
                        onPressed: onNext,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'Cấp ${beast.level} · ${beast.element.label} · ${beast.role}',
              ),
              Semantics(
                label: '${beast.stars} sao',
                excludeSemantics: true,
                child: Text(
                  beast.starsLabel,
                  style: GameTypography.heading.copyWith(
                    color: PixelUiColors.amber,
                  ),
                ),
              ),
              if (owned)
                MenuButton.tab(
                  label: favorite ? 'Đã yêu thích' : 'Yêu thích',
                  selected: favorite,
                  onPressed: onFavorite,
                )
              else
                const Text('Chưa thu thập', style: GameTypography.heading),
            ],
          ),
          MenuPanel(
            light: true,
            child: MenuGrid(
              minItemWidth: 92,
              maxColumns: 4,
              children: [
                for (final (label, value) in [
                  ('HP', hp),
                  ('ATK', attack),
                  ('DEF', defense),
                  ('SPD', speed),
                ])
                  Text('$label $value', style: GameTypography.heading),
              ],
            ),
          ),
          if (beast.moves.isNotEmpty)
            MenuPanel(
              title: 'Chiêu thức (${beast.moves.length})',
              light: true,
              child: MenuGrid(
                minItemWidth: 72,
                maxColumns: 4,
                children: [
                  for (final move in beast.moves)
                    MenuButton(
                      label: move.label,
                      artwork: move.artwork,
                      showLabel: true,
                      onPressed: () => showSampleDetail(
                        context,
                        move.label,
                        move.description,
                      ),
                    ),
                ],
              ),
            ),
          MenuGrid(
            children: [
              if (owned)
                MenuButton(
                  label: 'Nâng cấp',
                  skin: PixelFrameSkin.gold,
                  onPressed: () => showSampleDetail(
                    context,
                    'Nâng cấp ${beast.name}',
                    'Cấp hiện tại: ${beast.level}. Thẻ này minh họa thao tác nâng cấp yêu thú.',
                  ),
                ),
              MenuButton(
                label: 'Chi tiết',
                onPressed: () => showSampleDetail(
                  context,
                  beast.name,
                  'Cấp ${beast.level} · ${beast.stars} sao · Hệ ${beast.element.label}\n'
                  'Vai trò: ${beast.role}\n'
                  'HP $hp · ATK $attack · DEF $defense · SPD $speed',
                  icon: PixelIconKind.beasts,
                ),
              ),
            ],
          ),
          MenuButton(
            label: 'Xem thử trận chiến',
            icon: PixelIconKind.battle,
            showLabel: true,
            onPressed: onBattle,
          ),
        ],
      ),
    );
  }
}

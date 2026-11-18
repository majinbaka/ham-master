import 'package:flutter/material.dart';

import '../../../app/presentation/battle_move.dart';
import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/pixel/pixel_frame.dart';
import '../../../app/theme/game_typography.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import '../../beasts/presentation/beast_preview_data.dart';
import 'battle_arena.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({
    required this.onNavigate,
    required this.onBack,
    super.key,
  });

  final ValueChanged<String> onNavigate;
  final VoidCallback onBack;

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  var _move = BattleMove.flame;
  var _doubleSpeed = false;
  var _auto = false;
  var _paused = false;
  var _showTarget = false;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Trận chiến',
    selected: 'quests',
    onNavigate: widget.onNavigate,
    onBack: widget.onBack,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('Đợt 1 / 1', style: GameTypography.heading),
            MenuButton.tab(
              label: _doubleSpeed ? 'Tốc độ ×2' : 'Tốc độ ×1',
              selected: _doubleSpeed,
              onPressed: () => setState(() => _doubleSpeed = !_doubleSpeed),
            ),
            MenuButton.tab(
              label: 'Tự động',
              selected: _auto,
              onPressed: () => setState(() => _auto = !_auto),
            ),
            MenuButton.tab(
              label: _paused ? 'Tiếp tục' : 'Tạm dừng',
              selected: _paused,
              onPressed: () => setState(() => _paused = !_paused),
            ),
          ],
        ),
        const _BattleStatus(beast: BeastPreview.shadowWolf, enemy: true),
        BattleArena(
          targetSelected: _showTarget,
          onTarget: _paused ? null : () => setState(() => _showTarget = true),
        ),
        const _BattleStatus(beast: BeastPreview.fireFox),
        MenuPanel(
          title: 'Chiêu thức',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              MenuGrid(
                minItemWidth: 74,
                maxColumns: 4,
                children: [
                  for (final move in BeastPreview.fireFox.moves)
                    MenuButton(
                      label: move.label,
                      artwork: move.artwork,
                      selected: _move == move,
                      showLabel: true,
                      onPressed: _paused
                          ? null
                          : () => setState(() {
                              _move = move;
                              _showTarget = false;
                            }),
                    ),
                ],
              ),
              Semantics(
                liveRegion: true,
                child: Text(
                  _paused
                      ? 'Đang tạm dừng bản xem thử.'
                      : _showTarget
                      ? 'Mục tiêu: Sói Bóng Đêm · ${_move.label}'
                      : '${_move.label} · ${_move.description}',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _BattleStatus extends StatelessWidget {
  const _BattleStatus({required this.beast, this.enemy = false});

  final BeastPreview beast;
  final bool enemy;

  @override
  Widget build(BuildContext context) {
    final hp = beast.stats.$1;
    return PixelFrame(
      skin: enemy ? PixelFrameSkin.selected : PixelFrameSkin.cool,
      padding: const EdgeInsets.all(8),
      child: Row(
        spacing: 8,
        children: [
          if (!enemy) beast.sprite.artwork(48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Cấp ${beast.level} · ${beast.name}',
                      style: GameTypography.panelTitle,
                    ),
                    Text('HP $hp / $hp', style: GameTypography.caption),
                  ],
                ),
                PixelProgress(
                  value: 1,
                  height: 12,
                  label: 'Máu của ${beast.name}',
                  fillColor: enemy ? PixelUiColors.coral : PixelUiColors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

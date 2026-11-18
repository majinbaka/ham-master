import 'package:flutter/material.dart';

import '../../../app/presentation/battle_move.dart';
import '../../../app/presentation/menu_button.dart';
import 'battle_arena.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  static const _attacks = [BattleMove.flame, BattleMove.heat, BattleMove.claw];

  var _move = BattleMove.flame;
  var _cast = 0;
  var _showEffect = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/scenes/forest-arena.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
          excludeFromSemantics: true,
        ),
        SafeArea(
          minimum: const EdgeInsets.all(8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox.square(
                  dimension: 48,
                  child: IconButton(
                    tooltip: 'Quay lại',
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Expanded(
                child: BattleArena(
                  move: _move,
                  cast: _cast,
                  showEffect: _showEffect,
                  onTarget: () => setState(() {
                    _cast++;
                    _showEffect = true;
                  }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  for (final move in _attacks)
                    SizedBox(
                      width: 64,
                      child: MenuButton(
                        label: move.label,
                        artwork: move.artwork,
                        selected: _move == move,
                        onPressed: () => setState(() {
                          _move = move;
                          _showEffect = false;
                        }),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

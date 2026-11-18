import 'package:flutter/material.dart';

import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/traveler_portrait.dart';
import '../../../app/presentation/village_backdrop.dart';

/// Large text reflows in the shared scrolling content window instead of shrinking.
class HomeReadingView extends StatelessWidget {
  const HomeReadingView({
    required this.quests,
    required this.dialogue,
    required this.utilities,
    required this.actions,
    this.onNavigate,
    super.key,
  });

  final Widget quests;
  final Widget dialogue;
  final Widget utilities;
  final Widget actions;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Trang chủ',
    selected: 'home',
    onNavigate: onNavigate ?? (_) {},
    showBack: false,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        quests,
        const SizedBox(
          height: 96,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(child: VillageBackdrop()),
              SizedBox(
                width: 30,
                height: 54,
                child: TravelerPortrait(key: ValueKey('character-placeholder')),
              ),
            ],
          ),
        ),
        dialogue,
        utilities,
        actions,
      ],
    ),
  );
}

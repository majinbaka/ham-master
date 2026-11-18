import 'package:flutter/material.dart';

import '../../../app/presentation/village_backdrop.dart';
import '../../../app/presentation/traveler_portrait.dart';
import 'home_footer.dart';
import 'home_layout.dart';
import 'home_mail_button.dart';
import 'home_navigation.dart';
import 'home_reading_view.dart';

/// Fixed-proportion controls over a scene that expands with the viewport.
class HomeScreen extends StatefulWidget {
  const HomeScreen({this.onOpenBattle, this.onNavigate, super.key});

  final VoidCallback? onOpenBattle;
  final ValueChanged<String>? onNavigate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dialogueKey = GlobalKey();
  HomeAction? _action;

  void _showDialogue(HomeAction action) {
    setState(() => _action = action);
    final dialogueContext = _dialogueKey.currentContext;
    if (dialogueContext == null ||
        Scrollable.maybeOf(dialogueContext) == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!dialogueContext.mounted) return;
      Scrollable.ensureVisible(
        dialogueContext,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dialogue = HomeDialogue(key: _dialogueKey, action: _action);
    HomeActions actions(double scale) => HomeActions(
      scale: scale,
      onAction: _showDialogue,
      onOpenBattle: widget.onOpenBattle,
    );
    if (MediaQuery.textScalerOf(context).scale(17) > 17 * 1.15) {
      final layout = HomeLayout(MediaQuery.sizeOf(context));
      return HomeReadingView(
        onNavigate: widget.onNavigate,
        dialogue: dialogue,
        actions: SizedBox(
          height: layout.actionHeight,
          child: actions(layout.scale),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final layout = HomeLayout(
              constraints.biggest,
              deviceShortSide: MediaQuery.sizeOf(context).shortestSide,
            );
            return Stack(
              children: [
                const Positioned.fill(child: VillageBackdrop()),
                _placeControls(
                  'home-mail',
                  layout.mail,
                  const HomeMailButton(),
                ),
                Positioned.fromRect(
                  rect: layout.character,
                  child: const TravelerPortrait(
                    key: ValueKey('character-placeholder'),
                  ),
                ),
                _placeContent('home-dialogue', layout.dialogue, dialogue),
                _placeControls(
                  'home-actions',
                  layout.actions,
                  actions(layout.scale),
                ),
                _placeControls(
                  'home-navigation',
                  layout.navigation,
                  HomeNavigation(onNavigate: widget.onNavigate),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _placeControls(String key, Rect rect, Widget child) =>
      Positioned.fromRect(
        rect: rect,
        child: SizedBox(key: ValueKey(key), child: child),
      );

  Widget _placeContent(String key, Rect rect, Widget child) =>
      Positioned.fromRect(
        rect: rect,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(key: ValueKey(key), width: rect.width, child: child),
        ),
      );
}

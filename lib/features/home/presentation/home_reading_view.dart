import 'package:flutter/material.dart';

import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/menu_button.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import '../../../app/presentation/scaled_artwork.dart';
import '../../../app/presentation/game_chrome_layout.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import 'home_footer.dart';
import 'home_overview.dart';

/// Large text reflows in the shared scrolling content window instead of shrinking.
class HomeReadingView extends StatelessWidget {
  const HomeReadingView({
    required this.onInformation,
    this.onOpenQuests,
    this.onNavigate,
    super.key,
  });
  final VoidCallback onInformation;
  final VoidCallback? onOpenQuests;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Trang chủ',
    selected: 'home',
    onNavigate: onNavigate ?? (_) {},
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        HomeQuests(onOpen: onOpenQuests),
        const HomeMinimap(),
        const SizedBox(
          height: 96,
          child: Center(
            child: SizedBox(
              width: 30,
              height: 54,
              child: ColoredBox(
                key: ValueKey('character-placeholder'),
                color: PixelUiColors.gold,
              ),
            ),
          ),
        ),
        const HomeDialogue(),
        MenuButton(
          label: 'Thông tin màn hình',
          icon: PixelIconKind.info,
          onPressed: onInformation,
        ),
        Center(
          child: ScaledArtwork(
            size: const Size(840, 120),
            scale: GameChromeLayout(MediaQuery.sizeOf(context)).scale,
            child: const HomeActions(),
          ),
        ),
      ],
    ),
  );
}

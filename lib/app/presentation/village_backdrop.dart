import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';

/// Decorative illustration only; it does not expose a map or game state.
class VillageBackdrop extends StatelessWidget {
  const VillageBackdrop({this.softened = false, super.key});
  final bool softened;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/scenes/daylight-village.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
        if (softened)
          ColoredBox(color: PixelUiColors.paper.withValues(alpha: .56)),
      ],
    ),
  );
}

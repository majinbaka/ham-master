import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';

/// Decorative illustration only; it does not expose a map or game state.
class VillageBackdrop extends StatelessWidget {
  const VillageBackdrop({this.dimmed = false, super.key});
  final bool dimmed;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/scenes/twilight-village.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
        if (dimmed)
          ColoredBox(color: PixelUiColors.outline.withValues(alpha: .86)),
      ],
    ),
  );
}

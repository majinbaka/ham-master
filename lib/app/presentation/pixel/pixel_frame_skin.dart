import 'package:flutter/material.dart';

import '../../theme/game_surface_style.dart';
import '../../theme/pixel_ui_colors.dart';
import '../artwork_projection.dart';

/// Skins vary color only; geometry always comes from GameSurfaceStyle.
enum PixelFrameSkin {
  cream,
  cool,
  gold,
  cyan,
  paper,
  selected;

  Color get background => switch (this) {
    paper => PixelUiColors.paper,
    selected => PixelUiColors.peach,
    cream => PixelUiColors.surface,
    cool => PixelUiColors.mint,
    gold => PixelUiColors.gold,
    cyan => PixelUiColors.sky,
  };

  Color get buttonBackground => switch (this) {
    cream => PixelUiColors.buttonSand,
    cool => PixelUiColors.buttonMint,
    gold => PixelUiColors.buttonGold,
    cyan => PixelUiColors.buttonSky,
    paper => PixelUiColors.buttonPaper,
    selected => PixelUiColors.buttonPeach,
  };

  Color get border => switch (this) {
    cool => PixelUiColors.teal,
    gold => PixelUiColors.amber,
    selected => PixelUiColors.coral,
    cyan => PixelUiColors.blue,
    paper => PixelUiColors.amber,
    cream => PixelUiColors.frameBorder,
  };
}

/// The common border is painted in code so skins cannot alter its silhouette.
class PixelFrameArtwork extends StatelessWidget {
  const PixelFrameArtwork({required this.skin, super.key});
  final PixelFrameSkin skin;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: DecoratedBox(
      decoration: ShapeDecoration(
        color: skin.background,
        shape: GameSurfaceStyle.shape(
          color: skin.border,
          projection: ArtworkProjection.of(context),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import '../../theme/pixel_ui_colors.dart';
import '../../theme/game_typography.dart';
import 'pixel_frame_skin.dart';
import '../../theme/game_surface_style.dart';
import '../artwork_projection.dart';

export 'pixel_frame_skin.dart' show PixelFrameSkin;

/// A shared frame with identical screen-space borders at every artwork scale.
class PixelFrame extends StatelessWidget {
  const PixelFrame({
    required this.child,
    this.skin = PixelFrameSkin.cream,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  final Widget child;
  final PixelFrameSkin skin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(child: PixelFrameArtwork(skin: skin)),
      Padding(
        padding: padding.add(
          EdgeInsets.all(
            GameSurfaceStyle.borderWidth / ArtworkProjection.of(context),
          ),
        ),
        child: child,
      ),
    ],
  );
}

/// Fits copy inside a fixed artwork slot without resizing the surrounding UI.
/// Full text remains available to semantics; dialogs use normal text scaling.
class PixelLabel extends StatelessWidget {
  const PixelLabel(
    this.text, {
    this.fontSize = 26,
    this.color = PixelUiColors.paper,
    this.alignment = Alignment.center,
    super.key,
  });

  final String text;
  final double fontSize;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    alignment: alignment,
    child: Text(
      text,
      style: GameTypography.label.copyWith(fontSize: fontSize, color: color),
    ),
  );
}

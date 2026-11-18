import 'package:flutter/material.dart';

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

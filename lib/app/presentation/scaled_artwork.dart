import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'artwork_projection.dart';

/// Projects home artwork into its slot without scaling interactive menu content.
class ScaledArtwork extends StatelessWidget {
  const ScaledArtwork({
    required this.size,
    required this.scale,
    required this.child,
    super.key,
  });

  final Size size;
  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size.width * scale,
    height: size.height * scale,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final projection = math.min(
          constraints.maxWidth / size.width,
          constraints.maxHeight / size.height,
        );
        return FittedBox(
          fit: BoxFit.contain,
          child: SizedBox.fromSize(
            size: size,
            child: ArtworkProjection(
              scale: projection * ArtworkProjection.of(context),
              child: child,
            ),
          ),
        );
      },
    ),
  );
}

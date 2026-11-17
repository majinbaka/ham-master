import 'package:flutter/widgets.dart';

import 'pixel/pixel_art_scale.dart';

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
    child: FittedBox(
      fit: BoxFit.contain,
      child: SizedBox.fromSize(
        size: size,
        child: PixelArtScale(factor: 1, child: child),
      ),
    ),
  );
}

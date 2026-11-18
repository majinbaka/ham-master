import 'package:flutter/material.dart';

import 'pixel/pixel_frame.dart';
import 'pixel/pixel_icon.dart';
import 'village_backdrop.dart';

/// Compact illustrated chapter vignette with a foreground atlas emblem.
class MenuPreview extends StatelessWidget {
  const MenuPreview({required this.icon, super.key});
  final PixelIconKind icon;

  @override
  Widget build(BuildContext context) => PixelFrame(
    padding: const EdgeInsets.all(4),
    child: SizedBox(
      height: 96,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const VillageBackdrop(softened: true),
            Center(child: PixelIcon(icon, size: 48)),
          ],
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import 'pixel/pixel_frame.dart';
import 'pixel/pixel_icon.dart';

/// A bounded scene placeholder using the same black window as Home's minimap.
class MenuPreview extends StatelessWidget {
  const MenuPreview({required this.icon, super.key});
  final PixelIconKind icon;

  @override
  Widget build(BuildContext context) => PixelFrame(
    padding: const EdgeInsets.all(4),
    child: SizedBox(
      height: 64,
      child: ColoredBox(
        color: Colors.black,
        child: Center(child: PixelIcon(icon, size: 48)),
      ),
    ),
  );
}

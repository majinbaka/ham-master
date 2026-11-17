import 'package:flutter/widgets.dart';

/// Density of atlas artwork, independent of text size and touch targets.
/// Home paints in design units (1); menus paint at the same final device scale.
class PixelArtScale extends InheritedWidget {
  const PixelArtScale({required this.factor, required super.child, super.key});

  final double factor;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PixelArtScale>()?.factor ?? 1;

  @override
  bool updateShouldNotify(PixelArtScale oldWidget) =>
      factor != oldWidget.factor;
}

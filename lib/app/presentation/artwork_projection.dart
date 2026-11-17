import 'package:flutter/widgets.dart';

/// The outer artwork transform; borders compensate to retain screen-space size.
class ArtworkProjection extends InheritedWidget {
  const ArtworkProjection({
    required this.scale,
    required super.child,
    super.key,
  });
  final double scale;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ArtworkProjection>()?.scale ??
      1;

  @override
  bool updateShouldNotify(ArtworkProjection oldWidget) =>
      scale != oldWidget.scale;
}

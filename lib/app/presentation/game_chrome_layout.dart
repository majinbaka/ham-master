import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'game_spacing.dart';

/// Shared home/menu anchors, in the original 940-unit artwork coordinate system.
class GameChromeLayout {
  GameChromeLayout(this.viewport, {double? deviceShortSide})
    : scale = math.min(
        math.min((deviceShortSide ?? viewport.shortestSide) / 940, 390 / 940),
        viewport.width / 940,
      );

  final Size viewport;
  final double scale;

  static const profileSize = Size(440, 120);

  Rect get profile => _rect(
    GameSpacing.edge,
    GameSpacing.edge,
    profileSize.width,
    profileSize.height,
  );

  Rect get navigation {
    final height = math.max(160.0, 60 / scale);
    return _rect(
      (viewport.width / scale - 900) / 2,
      viewport.height / scale - GameSpacing.edge - height,
      900,
      height,
    );
  }

  Rect _rect(double x, double y, double width, double height) =>
      Rect.fromLTWH(x * scale, y * scale, width * scale, height * scale);
}

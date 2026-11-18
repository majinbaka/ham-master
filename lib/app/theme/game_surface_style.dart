import 'package:flutter/material.dart';

import 'pixel_ui_colors.dart';

/// Screen-space geometry shared by every game frame and control.
abstract final class GameSurfaceStyle {
  static const borderWidth = 2.0;
  static const cornerRadius = 8.0;

  static RoundedRectangleBorder shape({
    Color color = PixelUiColors.frameBorder,
    double projection = 1,
  }) => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(cornerRadius / projection),
    side: BorderSide(color: color, width: borderWidth / projection),
  );
}

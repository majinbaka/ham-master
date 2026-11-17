import 'package:flutter/material.dart';

import 'pixel_ui_colors.dart';
import 'game_typography.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GameTypography.family,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    primary: PixelUiColors.gold,
    onPrimary: PixelUiColors.outline,
    secondary: PixelUiColors.cyan,
    onSecondary: PixelUiColors.outline,
    surface: PixelUiColors.surface,
    onSurface: PixelUiColors.paper,
  ),
  textTheme: const TextTheme(
    bodyMedium: GameTypography.body,
    bodyLarge: GameTypography.body,
    bodySmall: GameTypography.caption,
    titleLarge: GameTypography.title,
    labelLarge: GameTypography.label,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(48, 56),
      foregroundColor: PixelUiColors.paper,
      disabledForegroundColor: PixelUiColors.cool,
      backgroundColor: PixelUiColors.surface,
      shape: gameControlShape(),
      textStyle: GameTypography.label,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      minimumSize: const Size(48, 48),
      foregroundColor: PixelUiColors.paper,
      backgroundColor: PixelUiColors.surface,
      shape: gameControlShape(),
    ),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: PixelUiColors.surface,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: PixelUiColors.cool, width: 2),
    ),
  ),
);

/// Controls share one silhouette, including Home's projected artwork.
RoundedRectangleBorder gameControlShape({
  bool selected = false,
  double scale = 1,
}) => RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(18 * scale),
  side: BorderSide(
    color: selected ? PixelUiColors.gold : PixelUiColors.cream,
    width: 2 * scale,
  ),
);

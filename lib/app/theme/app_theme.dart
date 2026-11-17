import 'package:flutter/material.dart';

import 'pixel_ui_colors.dart';
import 'game_typography.dart';
import 'game_surface_style.dart';

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
      shape: GameSurfaceStyle.shape(),
      textStyle: GameTypography.label,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      minimumSize: const Size(48, 48),
      foregroundColor: PixelUiColors.paper,
      backgroundColor: PixelUiColors.surface,
      shape: GameSurfaceStyle.shape(),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: PixelUiColors.surface,
    shape: GameSurfaceStyle.shape(color: PixelUiColors.cool),
  ),
);

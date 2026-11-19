import 'package:flutter/material.dart';

import 'game_surface_style.dart';
import 'game_typography.dart';
import 'pixel_ui_colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GameTypography.family,
  scaffoldBackgroundColor: PixelUiColors.mint,
  colorScheme: const ColorScheme.light(
    primary: PixelUiColors.teal,
    onPrimary: PixelUiColors.surface,
    secondary: PixelUiColors.coral,
    onSecondary: PixelUiColors.paper,
    surface: PixelUiColors.surface,
    onSurface: PixelUiColors.outline,
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
      foregroundColor: PixelUiColors.outline,
      disabledForegroundColor: PixelUiColors.mutedInk,
      backgroundColor: PixelUiColors.buttonSand,
      shape: GameSurfaceStyle.shape(color: PixelUiColors.outline),
      textStyle: GameTypography.label,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      minimumSize: const Size(48, 48),
      foregroundColor: PixelUiColors.outline,
      backgroundColor: PixelUiColors.buttonSand,
      shape: GameSurfaceStyle.shape(color: PixelUiColors.outline),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: PixelUiColors.paper,
    surfaceTintColor: Colors.transparent,
    shape: GameSurfaceStyle.shape(color: PixelUiColors.teal),
  ),
);

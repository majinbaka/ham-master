import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_frame_skin.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/app/theme/pixel_ui_colors.dart';

void main() {
  test('framed Material buttons keep their foreground and edge legible', () {
    for (final style in [
      appTheme.textButtonTheme.style!,
      appTheme.iconButtonTheme.style!,
    ]) {
      final fill = style.backgroundColor!.resolve({})!;
      final foreground = style.foregroundColor!.resolve({})!;
      final edge = style.shape!.resolve({})!.side.color;
      expect(fill.a, 1);
      expect(fill, isNot(PixelUiColors.surface));
      expect(_contrast(foreground, fill), greaterThanOrEqualTo(4.5));
      expect(_contrast(edge, fill), greaterThanOrEqualTo(3));
    }
  });

  test('shared light surfaces keep text and selection legible', () {
    final scheme = appTheme.colorScheme;
    expect(scheme.brightness, Brightness.light);
    for (final skin in PixelFrameSkin.values) {
      expect(_contrast(scheme.onSurface, skin.background), greaterThan(4.5));
      expect(
        _contrast(PixelUiColors.mutedInk, skin.background),
        greaterThan(4.5),
      );
      expect(_contrast(skin.border, skin.background), greaterThan(3));
    }
    expect(
      _contrast(PixelUiColors.coral, PixelFrameSkin.selected.background),
      greaterThan(4.5),
    );
    expect(
      _contrast(scheme.onSurface, appTheme.dialogTheme.backgroundColor!),
      greaterThan(4.5),
    );
  });
}

double _contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance() + 0.05;
  final b = background.computeLuminance() + 0.05;
  return a > b ? a / b : b / a;
}

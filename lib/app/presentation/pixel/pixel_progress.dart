import 'package:flutter/material.dart';

import '../../theme/pixel_ui_colors.dart';
import '../../theme/game_surface_style.dart';
import '../artwork_projection.dart';

/// EXP track using the same border and corner rule as panels and controls.
class PixelProgress extends StatelessWidget {
  const PixelProgress({
    required this.value,
    required this.label,
    this.height = 10,
    this.fillColor = PixelUiColors.gold,
    super.key,
  });
  final double? value;
  final double height;
  final Color fillColor;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    value: value == null ? null : '${(value! * 100).round()}%',
    child: Container(
      height: height,
      decoration: ShapeDecoration(
        color: PixelUiColors.outline,
        shape: GameSurfaceStyle.shape(
          projection: ArtworkProjection.of(context),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          GameSurfaceStyle.borderWidth / ArtworkProjection.of(context),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            (GameSurfaceStyle.cornerRadius - GameSurfaceStyle.borderWidth) /
                ArtworkProjection.of(context),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: (value ?? 0).clamp(0, 1),
              child: ColoredBox(
                color: fillColor,
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

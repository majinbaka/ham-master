import 'package:flutter/material.dart';

import '../../theme/pixel_ui_colors.dart';

/// The same square EXP track used by the home HUD, without Material rounding.
class PixelProgress extends StatelessWidget {
  const PixelProgress({
    required this.value,
    required this.label,
    this.height = 10,
    this.borderWidth = 1,
    super.key,
  });
  final double? value;
  final double height;
  final double borderWidth;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    value: value == null ? null : '${(value! * 100).round()}%',
    child: Container(
      height: height,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: PixelUiColors.outline,
        border: Border.all(color: PixelUiColors.cream, width: borderWidth),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: (value ?? 0).clamp(0, 1),
          child: const ColoredBox(
            color: PixelUiColors.gold,
            child: SizedBox.expand(),
          ),
        ),
      ),
    ),
  );
}

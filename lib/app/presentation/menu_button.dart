import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';
import '../theme/app_theme.dart';
import 'pixel/pixel_icon.dart';

/// Shared soft control. Icon buttons keep their name in tooltips and semantics.
class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.icon,
    this.artworkScale = 1,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final PixelIconKind? icon;

  /// Use only inside fixed artwork projected by ScaledArtwork.
  final double artworkScale;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    excludeFromSemantics: true,
    child: Semantics(
      label: icon == null ? null : label,
      selected: selected,
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 56),
          foregroundColor: selected ? PixelUiColors.gold : PixelUiColors.paper,
          disabledForegroundColor: PixelUiColors.cool,
          backgroundColor: selected
              ? PixelUiColors.raised
              : PixelUiColors.surface,
          padding: EdgeInsets.all(icon == null ? 8 : 6),
          shape: gameControlShape(selected: selected, scale: artworkScale),
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        onPressed: onPressed,
        child: icon == null
            ? Text(label, textAlign: TextAlign.center)
            : Stack(
                alignment: Alignment.center,
                children: [
                  PixelIcon(icon!, size: 36 * artworkScale),
                  if (selected)
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(Icons.check_circle, size: 14),
                    ),
                ],
              ),
      ),
    ),
  );
}

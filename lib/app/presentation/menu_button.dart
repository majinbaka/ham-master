import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';
import '../theme/game_surface_style.dart';
import 'artwork_projection.dart';
import 'pixel/pixel_icon.dart';

/// Shared soft control. Icon buttons keep their name in tooltips and semantics.
class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.icon,
    this.artworkScale = 1,
    this.showLabel = false,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final PixelIconKind? icon;

  /// Content cards show names; compact HUD actions keep tooltip-only labels.
  final bool showLabel;

  /// Scales the icon only; border geometry compensates for the outer projection.
  final double artworkScale;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    excludeFromSemantics: true,
    child: Semantics(
      label: icon == null || showLabel ? null : label,
      selected: selected,
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 56),
          foregroundColor: selected ? PixelUiColors.gold : PixelUiColors.paper,
          disabledForegroundColor: selected
              ? PixelUiColors.gold
              : PixelUiColors.cool,
          backgroundColor: selected
              ? PixelUiColors.raised
              : PixelUiColors.surface,
          padding: EdgeInsets.all(icon == null ? 8 : 6),
          shape: GameSurfaceStyle.shape(
            color: selected ? PixelUiColors.gold : PixelUiColors.cream,
            projection: ArtworkProjection.of(context),
          ),
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        onPressed: onPressed,
        child: icon == null
            ? Text(label, textAlign: TextAlign.center)
            : Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Stack(
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
                  if (showLabel) Text(label, textAlign: TextAlign.center),
                ],
              ),
      ),
    ),
  );
}

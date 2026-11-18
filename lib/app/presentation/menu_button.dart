import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';
import '../theme/game_surface_style.dart';
import 'artwork_projection.dart';
import 'pixel/pixel_frame_skin.dart';
import 'pixel/pixel_icon.dart';

/// Shared soft control. Icon buttons keep their name in tooltips and semantics.
class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.skin = PixelFrameSkin.cream,
    this.icon,
    this.artwork,
    this.artworkScale = 1,
    this.showLabel = false,
    super.key,
  }) : _isTab = false;

  /// Compact text control for switching between views or settings options.
  const MenuButton.tab({
    required this.label,
    required this.onPressed,
    required this.selected,
    super.key,
  }) : _isTab = true,
       skin = PixelFrameSkin.cream,
       icon = null,
       artwork = null,
       artworkScale = 1,
       showLabel = false;

  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final PixelFrameSkin skin;
  final PixelIconKind? icon;
  final Widget? artwork;
  final bool _isTab;

  /// Content cards show names; compact HUD actions keep tooltip-only labels.
  final bool showLabel;

  /// Scales the icon only; border geometry compensates for the outer projection.
  final double artworkScale;

  @override
  Widget build(BuildContext context) {
    final visual =
        artwork ??
        (icon == null ? null : PixelIcon(icon!, size: 36 * artworkScale));
    final frame = selected ? PixelFrameSkin.selected : skin;
    return Tooltip(
      message: label,
      excludeFromSemantics: true,
      child: Semantics(
        label: visual == null || showLabel ? null : label,
        selected: selected,
        child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: _isTab ? const Size(48, 40) : const Size(48, 56),
            tapTargetSize: _isTab ? MaterialTapTargetSize.padded : null,
            visualDensity: _isTab ? VisualDensity.standard : null,
            foregroundColor: selected
                ? PixelUiColors.coral
                : PixelUiColors.outline,
            disabledForegroundColor: PixelUiColors.mutedInk,
            backgroundColor: frame.background,
            disabledBackgroundColor: frame.background,
            padding: _isTab
                ? const EdgeInsets.symmetric(horizontal: 6, vertical: 4)
                : EdgeInsets.all(visual == null ? 8 : 6),
            shape: GameSurfaceStyle.shape(
              color: frame.border,
              projection: ArtworkProjection.of(context),
            ),
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: onPressed,
          child: visual == null
              ? Text(label, textAlign: TextAlign.center)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    visual,
                    if (showLabel) Text(label, textAlign: TextAlign.center),
                  ],
                ),
        ),
      ),
    );
  }
}

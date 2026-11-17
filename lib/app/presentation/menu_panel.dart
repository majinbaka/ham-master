import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';
import '../theme/game_typography.dart';
import 'pixel/pixel_frame.dart';

/// Home's floating title tab and quiet panel body, at the shared atlas density.
class MenuPanel extends StatelessWidget {
  const MenuPanel({
    required this.child,
    this.title,
    this.light = false,
    super.key,
  });

  final Widget child;
  final String? title;
  final bool light;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: title == null ? 0 : 16),
          child: PixelFrame(
            skin: light ? PixelFrameSkin.paper : PixelFrameSkin.cool,
            padding: EdgeInsets.fromLTRB(8, title == null ? 8 : 24, 8, 8),
            child: DefaultTextStyle.merge(
              style: GameTypography.body.copyWith(
                color: light ? PixelUiColors.outline : PixelUiColors.paper,
              ),
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        ),
        if (title != null)
          Positioned(
            top: 0,
            left: 8,
            right: 8,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: math.min(280, constraints.maxWidth - 16),
                  ),
                  child: SizedBox(
                    height: 32,
                    child: PixelFrame(
                      skin: PixelFrameSkin.gold,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: PixelLabel(
                        title!,
                        fontSize: 16,
                        color: PixelUiColors.gold,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

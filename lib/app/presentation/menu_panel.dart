import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';
import '../theme/game_typography.dart';
import '../theme/game_surface_style.dart';
import 'pixel/pixel_frame.dart';

/// Home's floating title tab and panel body, with the common border geometry.
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
    builder: (context, constraints) {
      final titleWidth = math.min(280.0, constraints.maxWidth - 16);
      const inset = 2 * GameSurfaceStyle.borderWidth;
      final titleStyle = Theme.of(context).textTheme.labelLarge!
          .merge(GameTypography.panelTitle)
          .copyWith(color: PixelUiColors.outline);
      final painter = TextPainter(
        text: TextSpan(text: title ?? '', style: titleStyle),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 2,
        ellipsis: '…',
      )..layout(maxWidth: math.max(0, titleWidth - 16 - inset));
      final titleHeight = math.max(32.0, painter.height + 8 + inset);
      painter.dispose();
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: title == null ? 0 : titleHeight / 2),
            child: PixelFrame(
              skin: light ? PixelFrameSkin.paper : PixelFrameSkin.cool,
              padding: EdgeInsets.fromLTRB(
                8,
                title == null ? 8 : titleHeight / 2 + 8,
                8,
                8,
              ),
              child: DefaultTextStyle.merge(
                style: GameTypography.body.copyWith(
                  color: PixelUiColors.outline,
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
                    constraints: BoxConstraints(maxWidth: titleWidth),
                    child: SizedBox(
                      height: titleHeight,
                      child: PixelFrame(
                        skin: PixelFrameSkin.gold,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title!,
                            style: titleStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

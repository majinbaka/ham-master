import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';

/// Static pixel portrait; no movement, equipment or player state.
class TravelerPortrait extends StatelessWidget {
  const TravelerPortrait({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Nhà lữ hành minh họa với mũ vàng và áo choàng tím',
    child: const CustomPaint(painter: _TravelerPainter()),
  );
}

class _TravelerPainter extends CustomPainter {
  const _TravelerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 12, size.height / 20);
    final paint = Paint()..isAntiAlias = false;
    void block(double x, double y, double w, double h, Color color) {
      paint.color = color;
      canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);
    }

    block(2, 18, 9, 2, PixelUiColors.outline);
    block(2, 10, 9, 7, PixelUiColors.outline);
    block(3, 10, 7, 6, PixelUiColors.cool);
    block(5, 10, 3, 6, PixelUiColors.raised);
    block(3, 16, 3, 3, PixelUiColors.raised);
    block(7, 16, 3, 3, PixelUiColors.raised);
    block(3, 3, 7, 7, PixelUiColors.outline);
    block(4, 4, 6, 5, PixelUiColors.cream);
    block(5, 6, 1, 1, PixelUiColors.outline);
    block(8, 6, 1, 1, PixelUiColors.outline);
    block(3, 1, 6, 3, PixelUiColors.gold);
    block(1, 4, 11, 1, PixelUiColors.gold);
    block(3, 3, 6, 1, PixelUiColors.cream);
    block(7, 1, 1, 2, PixelUiColors.cyan);
    block(1, 11, 2, 4, PixelUiColors.cream);
    block(10, 11, 2, 4, PixelUiColors.cream);
    block(5, 10, 3, 1, PixelUiColors.gold);
  }

  @override
  bool shouldRepaint(_TravelerPainter oldDelegate) => false;
}

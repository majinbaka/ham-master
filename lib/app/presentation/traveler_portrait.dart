import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';

/// Static pixel portrait; no movement, equipment or player state.
class TravelerPortrait extends StatelessWidget {
  const TravelerPortrait({
    this.hat = PixelUiColors.gold,
    this.coat = PixelUiColors.teal,
    this.trim = PixelUiColors.blue,
    super.key,
  });

  final Color hat;
  final Color coat;
  final Color trim;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Chân dung nhà lữ hành',
    child: CustomPaint(painter: _TravelerPainter(hat, coat, trim)),
  );
}

class _TravelerPainter extends CustomPainter {
  const _TravelerPainter(this.hat, this.coat, this.trim);

  final Color hat;
  final Color coat;
  final Color trim;

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
    block(3, 10, 7, 6, coat);
    block(5, 10, 3, 6, trim);
    block(3, 16, 3, 3, trim);
    block(7, 16, 3, 3, trim);
    block(3, 3, 7, 7, PixelUiColors.outline);
    block(4, 4, 6, 5, PixelUiColors.peach);
    block(5, 6, 1, 1, PixelUiColors.outline);
    block(8, 6, 1, 1, PixelUiColors.outline);
    block(3, 1, 6, 3, hat);
    block(1, 4, 11, 1, hat);
    block(3, 3, 6, 1, PixelUiColors.peach);
    block(7, 1, 1, 2, PixelUiColors.sky);
    block(1, 11, 2, 4, PixelUiColors.peach);
    block(10, 11, 2, 4, PixelUiColors.peach);
    block(5, 10, 3, 1, hat);
  }

  @override
  bool shouldRepaint(_TravelerPainter oldDelegate) =>
      oldDelegate.hat != hat ||
      oldDelegate.coat != coat ||
      oldDelegate.trim != trim;
}

import 'package:flutter/material.dart';

/// A determinate, beveled neon bar inspired by the supplied loading artwork.
class NeonProgressBar extends StatelessWidget {
  const NeonProgressBar({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Loading',
    value: '${(progress * 100).round()}%',
    child: CustomPaint(
      size: const Size(double.infinity, 30),
      painter: _NeonBarPainter(progress),
    ),
  );
}

class _NeonBarPainter extends CustomPainter {
  _NeonBarPainter(this.progress);

  final double progress;

  Path _bevel(Rect rect) {
    final corner = (rect.height / 2).clamp(0.0, 7.0);
    return Path()
      ..moveTo(rect.left + corner, rect.top)
      ..lineTo(rect.right - corner, rect.top)
      ..lineTo(rect.right, rect.top + corner)
      ..lineTo(rect.right, rect.bottom - corner)
      ..lineTo(rect.right - corner, rect.bottom)
      ..lineTo(rect.left + corner, rect.bottom)
      ..lineTo(rect.left, rect.bottom - corner)
      ..lineTo(rect.left, rect.top + corner)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(2);
    final outline = _bevel(rect);
    canvas.drawPath(outline, Paint()..color = const Color(0xFF242229));
    canvas.drawPath(
      outline,
      Paint()
        ..color = const Color(0xFF9D94A4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    if (progress <= 0) return;
    final fill = Rect.fromLTWH(
      rect.left,
      rect.top,
      rect.width * progress.clamp(0, 1),
      rect.height,
    );
    canvas.drawRect(
      fill,
      Paint()
        ..color = const Color(0xFFFF7900)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    canvas.save();
    canvas.clipPath(outline);
    canvas.clipRect(fill);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFEB68), Color(0xFFFF9D00), Color(0xFFFF5C00)],
        ).createShader(rect),
    );
    final stripePaint = Paint()..color = const Color(0x88FFF18A);
    for (var x = -size.height; x < size.width; x += 32) {
      canvas.drawPath(
        Path()
          ..moveTo(x, rect.bottom)
          ..lineTo(x + 14, rect.bottom)
          ..lineTo(x + 14 + rect.height, rect.top)
          ..lineTo(x + rect.height, rect.top)
          ..close(),
        stripePaint,
      );
    }
    canvas.drawPath(
      _bevel(rect.deflate(3)),
      Paint()
        ..color = const Color(0xFFFFF5C8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_NeonBarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

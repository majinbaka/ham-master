import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'pixel_art_scale.dart';

/// Sprite bounds in frame-atlas.png. Each 448 × 440 sprite has 56 px caps.
/// Artwork is rendered at 1/4 size; corners stay 14 design units when resized.
enum PixelFrameSkin {
  cream(48, 40),
  cool(544, 40),
  gold(1040, 40),
  cyan(48, 540),
  paper(544, 540),
  selected(1040, 540);

  const PixelFrameSkin(this.x, this.y);

  final double x;
  final double y;

  static const asset = 'assets/ui/frame-atlas.png';
}

/// Shares Flutter's cached atlas and draws only the selected nine-slice region.
class PixelFrameArtwork extends StatefulWidget {
  const PixelFrameArtwork({required this.skin, super.key});

  final PixelFrameSkin skin;

  @override
  State<PixelFrameArtwork> createState() => _PixelFrameArtworkState();
}

class _PixelFrameArtworkState extends State<PixelFrameArtwork> {
  ImageStream? _stream;
  ImageInfo? _image;
  late final _listener = ImageStreamListener(_receiveImage);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final stream = const AssetImage(
      PixelFrameSkin.asset,
    ).resolve(createLocalImageConfiguration(context));
    if (_stream?.key == stream.key) return;
    _stream?.removeListener(_listener);
    _stream = stream;
    stream.addListener(_listener);
  }

  void _receiveImage(ImageInfo image, bool synchronousCall) {
    setState(() {
      _image?.dispose();
      _image = image;
    });
  }

  @override
  void dispose() {
    _stream?.removeListener(_listener);
    _image?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      painter: _SpriteFramePainter(
        image: _image?.image,
        skin: widget.skin,
        scale: PixelArtScale.of(context),
      ),
    ),
  );
}

class _SpriteFramePainter extends CustomPainter {
  const _SpriteFramePainter({
    required this.image,
    required this.skin,
    required this.scale,
  });

  final ui.Image? image;
  final double scale;
  final PixelFrameSkin skin;

  @override
  void paint(Canvas canvas, Size size) {
    final atlas = image;
    if (atlas == null || size.isEmpty) return;
    // Small slots shrink both caps equally instead of overlapping the corners.
    final cap = math.min(14.0 * scale, size.shortestSide / 2);
    final sourceX = [skin.x, skin.x + 56, skin.x + 392, skin.x + 448];
    final sourceY = [skin.y, skin.y + 56, skin.y + 384, skin.y + 440];
    final targetX = [0.0, cap, size.width - cap, size.width];
    final targetY = [0.0, cap, size.height - cap, size.height];
    final paint = Paint()
      ..isAntiAlias = false
      ..filterQuality = FilterQuality.none;

    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        final destination = Rect.fromLTRB(
          targetX[col],
          targetY[row],
          targetX[col + 1],
          targetY[row + 1],
        );
        if (destination.isEmpty) continue;
        canvas.drawImageRect(
          atlas,
          Rect.fromLTRB(
            sourceX[col],
            sourceY[row],
            sourceX[col + 1],
            sourceY[row + 1],
          ),
          destination,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SpriteFramePainter oldDelegate) =>
      oldDelegate.image != image ||
      oldDelegate.skin != skin ||
      oldDelegate.scale != scale;
}

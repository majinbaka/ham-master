import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Measured square regions in the production icon atlas, in row order.
enum PixelIconKind {
  coin,
  gem,
  energy,
  home,
  compass,
  beasts,
  battle,
  backpack,
  story,
  quest,
  bookmark,
  lock,
  mail,
  tasks,
  info,
  talk,
  observe,
  search;

  static const asset = 'assets/ui/icon-atlas.png';

  Rect get source => Rect.fromLTWH(
    (index % 6) * 256.0,
    const [64.0, 388.0, 720.0][index ~/ 6],
    256,
    256,
  );
}

/// Decorative artwork; surrounding controls and labels own its semantics.
class PixelIcon extends StatefulWidget {
  const PixelIcon(this.kind, {required this.size, super.key});

  final PixelIconKind kind;
  final double size;

  @override
  State<PixelIcon> createState() => _PixelIconState();
}

class _PixelIconState extends State<PixelIcon> {
  ImageStream? _stream;
  ImageInfo? _image;
  late final _listener = ImageStreamListener(_receiveImage);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final stream = const AssetImage(
      PixelIconKind.asset,
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
    child: SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(
        painter: _IconPainter(image: _image?.image, kind: widget.kind),
      ),
    ),
  );
}

class _IconPainter extends CustomPainter {
  const _IconPainter({required this.image, required this.kind});

  final ui.Image? image;
  final PixelIconKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final atlas = image;
    if (atlas == null || size.isEmpty) return;
    canvas.drawImageRect(
      atlas,
      kind.source,
      Offset.zero & size,
      Paint()
        ..isAntiAlias = false
        ..filterQuality = FilterQuality.none,
    );
  }

  @override
  bool shouldRepaint(_IconPainter oldDelegate) =>
      image != oldDelegate.image || kind != oldDelegate.kind;
}

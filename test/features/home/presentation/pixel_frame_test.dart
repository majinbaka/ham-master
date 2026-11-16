import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/features/home/presentation/pixel_frame_skin.dart';

void main() {
  testWidgets('all sprite skins preserve corners when panels grow', (
    tester,
  ) async {
    for (final skin in PixelFrameSkin.values) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final size in [const Size(120, 70), const Size(240, 110)])
                  RepaintBoundary(
                    key: ValueKey(size),
                    child: SizedBox.fromSize(
                      size: size,
                      child: PixelFrameArtwork(skin: skin),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => precacheImage(
          const AssetImage(PixelFrameSkin.asset),
          tester.element(find.byType(PixelFrameArtwork).first),
        ),
      );
      await tester.pumpAndSettle();

      final small = await _pixels(tester, const Size(120, 70));
      final large = await _pixels(tester, const Size(240, 110));
      for (final right in [false, true]) {
        for (final bottom in [false, true]) {
          expect(
            _corner(large, 240, 110, right: right, bottom: bottom),
            _corner(small, 120, 70, right: right, bottom: bottom),
            reason: '$skin must preserve all four corner sprites',
          );
        }
      }
      // A missing asset could otherwise pass the equality check as two blanks.
      expect(small[(35 * 120 + 60) * 4 + 3], greaterThan(250));
      // No transparent seam may appear where an edge joins its corner/center.
      for (var x = 12; x < 228; x++) {
        expect(large[(6 * 240 + x) * 4 + 3], greaterThan(240));
      }
      expect(tester.takeException(), isNull);
    }
    // Removing listeners while images are cached must also be safe.
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });
}

Future<Uint8List> _pixels(WidgetTester tester, Size size) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(ValueKey(size)),
  );
  return (await tester.runAsync(() async {
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    return bytes!.buffer.asUint8List();
  }))!;
}

List<int> _corner(
  Uint8List pixels,
  int width,
  int height, {
  required bool right,
  required bool bottom,
}) => [
  for (var y = bottom ? height - 14 : 0; y < (bottom ? height : 14); y++)
    for (var x = right ? width - 14 : 0; x < (right ? width : 14); x++)
      ...pixels.sublist((y * width + x) * 4, (y * width + x) * 4 + 4),
];

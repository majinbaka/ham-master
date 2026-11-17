import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_frame_skin.dart';
import 'package:pixel_rpg/app/presentation/scaled_artwork.dart';

void main() {
  testWidgets(
    'skins and projected HUDs share the same two-pixel border and corners',
    (tester) async {
      Uint8List? reference;
      for (final skin in PixelFrameSkin.values) {
        for (final scale in [1.0, 390 / 940, 320 / 940]) {
          final captures = <Uint8List>[];
          for (final size in [const Size(120, 70), const Size(240, 110)]) {
            await tester.pumpWidget(
              Directionality(
                textDirection: TextDirection.ltr,
                child: Center(
                  child: RepaintBoundary(
                    key: const ValueKey('frame'),
                    child: ScaledArtwork(
                      size: Size(size.width / scale, size.height / scale),
                      scale: scale,
                      child: PixelFrameArtwork(skin: skin),
                    ),
                  ),
                ),
              ),
            );
            await tester.pump();
            final pixels = await _pixels(tester);
            captures.add(pixels);
            final width = size.width.toInt();
            // Top center: exactly two border rows, then the panel fill.
            for (final y in [0, 1, 2, 3]) {
              final offset = (y * width + width ~/ 2) * 4;
              final color = Color.fromARGB(
                pixels[offset + 3],
                pixels[offset],
                pixels[offset + 1],
                pixels[offset + 2],
              );
              expect(
                color,
                y < 2 ? skin.border : skin.background,
                reason: '$skin / scale $scale / row $y',
              );
            }
            // Compare alpha at an 8 x 8 corner across skins, sizes and projections.
            final corner = Uint8List.fromList([
              for (var y = 0; y < 8; y++)
                for (var x = 0; x < 8; x++) pixels[(y * width + x) * 4 + 3],
            ]);
            reference ??= corner;
            for (var i = 0; i < corner.length; i++) {
              expect(
                corner[i],
                closeTo(reference[i], 2),
                reason: '$skin / $scale corner $i',
              );
            }
            expect(corner.first, 0);
            expect(corner.last, 255);
            expect(tester.takeException(), isNull);
          }
          // Every corner retains its geometry when the panel grows.
          for (final right in [false, true]) {
            for (final bottom in [false, true]) {
              final a = _corner(
                captures[0],
                120,
                70,
                right: right,
                bottom: bottom,
              );
              final b = _corner(
                captures[1],
                240,
                110,
                right: right,
                bottom: bottom,
              );
              for (var i = 0; i < a.length; i++) {
                // Coverage can differ slightly at the antialiased edge; the
                // visible silhouette must occupy the exact same pixels.
                expect(a[i] >= 128, b[i] >= 128);
              }
            }
          }
        }
      }
    },
  );
}

Future<Uint8List> _pixels(WidgetTester tester) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('frame')),
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
  for (var y = bottom ? height - 8 : 0; y < (bottom ? height : 8); y++)
    for (var x = right ? width - 8 : 0; x < (right ? width : 8); x++)
      pixels[(y * width + x) * 4 + 3],
];

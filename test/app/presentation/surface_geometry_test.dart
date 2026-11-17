import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_button.dart';
import 'package:pixel_rpg/app/presentation/scaled_artwork.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';

void main() {
  testWidgets(
    'buttons, back controls and dialogs match at every artwork projection',
    (tester) async {
      for (final scale in [1.0, 390 / 940, 320 / 940]) {
        for (final selected in [false, true]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: appTheme,
              home: Center(
                child: ScaledArtwork(
                  size: Size(120 / scale, 70 / scale),
                  scale: scale,
                  child: MenuButton(
                    label: 'Chọn',
                    selected: selected,
                    artworkScale: 2,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          );
          final button = tester.widget<TextButton>(find.byType(TextButton));
          final shape =
              button.style!.shape!.resolve({})! as RoundedRectangleBorder;
          expect(shape.side.width * scale, closeTo(2, 0.0001));
          expect(
            shape.borderRadius.resolve(TextDirection.ltr).topLeft.x * scale,
            closeTo(8, 0.0001),
          );
        }
      }
      // A narrow parent can constrain artwork below its requested scale.
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: Center(
            child: SizedBox(
              width: 90,
              child: ScaledArtwork(
                size: const Size(300, 120),
                scale: .5,
                child: MenuButton(label: 'Hẹp', onPressed: () {}),
              ),
            ),
          ),
        ),
      );
      final control = find.byType(TextButton);
      final matrix = tester.renderObject(control).getTransformTo(null);
      final transform =
          (MatrixUtils.transformPoint(matrix, const Offset(1, 0)) -
                  MatrixUtils.transformPoint(matrix, Offset.zero))
              .distance;
      final shape =
          tester.widget<TextButton>(control).style!.shape!.resolve({})!
              as RoundedRectangleBorder;
      expect(shape.side.width * transform, closeTo(2, .0001));
      expect(
        shape.borderRadius.resolve(TextDirection.ltr).topLeft.x * transform,
        closeTo(8, .0001),
      );
      final back =
          appTheme.iconButtonTheme.style!.shape!.resolve({})!
              as RoundedRectangleBorder;
      final dialog = appTheme.dialogTheme.shape! as RoundedRectangleBorder;
      for (final shape in [back, dialog]) {
        expect(shape.side.width, 2);
        expect(shape.borderRadius.resolve(TextDirection.ltr).topLeft.x, 8);
      }
    },
  );
}

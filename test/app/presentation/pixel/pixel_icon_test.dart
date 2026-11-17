import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_icon.dart';

void main() {
  for (final horizontal in [true, false]) {
    testWidgets(
      'icons stay square inside a stretched ${horizontal ? 'row' : 'column'}',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 100,
                child: Flex(
                  direction: horizontal ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [PixelIcon(PixelIconKind.talk, size: 40)],
                ),
              ),
            ),
          ),
        );
        final paint = find.descendant(
          of: find.byType(PixelIcon),
          matching: find.byType(CustomPaint),
        );
        expect(tester.getRect(paint).size, const Size(40, 40));
        expect(tester.takeException(), isNull);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_grid.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('cards keep aligned rows at text scale $scale', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: const Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 340,
                child: MenuGrid(
                  children: [
                    SizedBox(key: ValueKey(0), height: 48),
                    SizedBox(key: ValueKey(1), height: 72),
                    SizedBox(key: ValueKey(2), height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      final first = tester.getRect(find.byKey(const ValueKey(0)));
      final second = tester.getRect(find.byKey(const ValueKey(1)));
      final third = tester.getRect(find.byKey(const ValueKey(2)));
      if (scale == 1) {
        expect(first.top, second.top);
        expect(first.bottom, second.bottom);
        expect(second.left - first.right, 8);
        expect(third.top - first.bottom, 8);
        expect(third.width, first.width);
      } else {
        expect(first.width, 340);
        expect(second.top - first.bottom, 8);
        expect(third.top - second.bottom, 8);
      }
      expect(tester.takeException(), isNull);
    });
  }
}

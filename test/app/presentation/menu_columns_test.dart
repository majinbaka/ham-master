import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_components.dart';

void main() {
  for (final (width, scale, stacked) in [
    (320.0, 1.0, true),
    (390.0, 1.0, true),
    (760.0, 1.0, false),
    (760.0, 2.0, true),
  ]) {
    testWidgets('master/detail at width $width and text scale $scale', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: const Scaffold(
            body: MenuColumns(
              leading: SizedBox(key: ValueKey('list'), height: 80),
              detail: SizedBox(key: ValueKey('detail'), height: 120),
            ),
          ),
        ),
      );
      final list = tester.getRect(find.byKey(const ValueKey('list')));
      final detail = tester.getRect(find.byKey(const ValueKey('detail')));
      if (stacked) {
        expect(detail.top, greaterThanOrEqualTo(list.bottom + 8));
        expect(detail.width, width);
      } else {
        expect(detail.left, greaterThanOrEqualTo(list.right + 8));
        expect(detail.top, list.top);
      }
      expect(tester.takeException(), isNull);
    });
  }
}

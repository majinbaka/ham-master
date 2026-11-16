import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/home/presentation/home_screen.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('home remains usable at $size with text scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: appTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const HomeScreen(),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Chưa có nhiệm vụ'), findsOneWidget);
        await tester.ensureVisible(
          find.byKey(const ValueKey('character-placeholder')),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('character-placeholder')).hitTestable(),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text('Trang chủ'));
        await tester.pumpAndSettle();
        expect(find.text('Trang chủ').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'information explains unavailable gameplay and can be dismissed',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: appTheme, home: const HomeScreen()),
      );
      await tester.tap(find.byTooltip('Thông tin màn hình'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('khối vàng trên nền đen'), findsOneWidget);
      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );
}

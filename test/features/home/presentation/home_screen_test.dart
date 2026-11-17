import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/app/presentation/pixel_navigation.dart';
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
        await tester.ensureVisible(find.byTooltip('Trang chủ'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Trang chủ').hitTestable(), findsOneWidget);
        final controls = find.descendant(
          of: find.byType(PixelNavigation),
          matching: find.byType(TextButton),
        );
        for (final control in controls.evaluate()) {
          final target = tester.getSize(find.byWidget(control.widget));
          expect(target.width, greaterThanOrEqualTo(48));
          expect(target.height, greaterThanOrEqualTo(48));
        }
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

  testWidgets(
    'large Home copy scrolls to dialogue and information without moving navigation',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: const HomeScreen(),
        ),
      );
      final nav = tester.getRect(find.byType(PixelNavigation));
      await tester.ensureVisible(find.text('Hành trình mới đang chờ bạn.'));
      await tester.pumpAndSettle();
      expect(
        find.text('Hành trình mới đang chờ bạn.').hitTestable(),
        findsOneWidget,
      );
      await tester.ensureVisible(find.byTooltip('Thông tin màn hình'));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(PixelNavigation)), nav);
      await tester.tap(find.byTooltip('Thông tin màn hình'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

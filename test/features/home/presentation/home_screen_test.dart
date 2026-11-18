import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_icon.dart';
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
            home: HomeScreen(onOpenBattle: () {}),
          ),
        );
        expect(tester.takeException(), isNull);
        for (final label in [
          'Cốt truyện',
          'Nhiệm vụ',
          'Mở Nhiệm vụ',
          'Mở Nhiệm vụ phụ',
          'Nhiệm vụ hàng ngày',
          'Thông tin màn hình',
        ]) {
          expect(find.byTooltip(label), findsNothing);
        }
        expect(find.text('Nhiệm vụ chính'), findsNothing);
        expect(find.text('Nhiệm vụ phụ'), findsNothing);
        await tester.ensureVisible(
          find.byKey(const ValueKey('character-placeholder')),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('character-placeholder')).hitTestable(),
          findsOneWidget,
        );
        final battle = find.byTooltip('Trận chiến');
        await tester.ensureVisible(battle);
        await tester.pumpAndSettle();
        expect(battle.hitTestable(), findsOneWidget);
        expect(tester.getSize(battle).shortestSide, greaterThanOrEqualTo(48));
        await tester.ensureVisible(find.byTooltip('Trang chủ'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Trang chủ').hitTestable(), findsOneWidget);
        final controls = find.descendant(
          of: find.byType(PixelNavigation),
          matching: find.byType(TextButton),
        );
        expect(controls, findsNWidgets(4));
        for (final control in controls.evaluate()) {
          final target = tester.getSize(find.byWidget(control.widget));
          expect(target.width, greaterThanOrEqualTo(48));
          expect(target.height, greaterThanOrEqualTo(48));
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('mail is an unframed icon with a 48 dp touch target', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(theme: appTheme, home: const HomeScreen()),
    );

    final mail = find.byTooltip('Hộp thư');
    final button = tester.widget<IconButton>(find.byType(IconButton));
    expect(button.icon, isA<PixelIcon>());
    expect(tester.getSize(mail), const Size.square(48));
    expect(button.style!.backgroundColor!.resolve({}), Colors.transparent);
    expect(button.style!.shape!.resolve({})!.side, BorderSide.none);
    expect(tester.getSemantics(mail).tooltip, 'Hộp thư');
    semantics.dispose();

    await tester.tapAt(tester.getTopLeft(mail) + const Offset(8, 8));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AlertDialog, 'Hộp thư'), findsOneWidget);
    expect(find.textContaining('Chưa có thư'), findsOneWidget);
  });

  testWidgets(
    'large Home copy scrolls to dialogue and mail without moving navigation',
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
      await tester.ensureVisible(find.byTooltip('Hộp thư'));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(PixelNavigation)), nav);
      await tester.tap(find.byTooltip('Hộp thư'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Đóng'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/pixel_rpg_app.dart';
import 'package:pixel_rpg/app/router/app_router.dart';
import 'package:pixel_rpg/features/home/presentation/home_screen.dart';
import 'package:pixel_rpg/features/quests/presentation/quest_screen.dart';

void main() {
  testWidgets('home opens quest preview and both controls return home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: PixelRpgApp()));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(PixelRpgApp)),
    );
    final router = container.read(appRouterProvider);

    for (final back in [
      find.byTooltip('Quay lại'),
      find.byTooltip('Trang chủ'),
    ]) {
      await tester.tap(find.byTooltip('Mở Nhiệm vụ'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/home/quests');
      expect(find.byType(QuestScreen), findsOneWidget);
      expect(find.byTooltip('Chương 1\nKhởi hành'), findsOneWidget);
      expect(find.text('Bước chân đầu tiên'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(back);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/home');
      expect(find.byType(HomeScreen), findsOneWidget);
    }
  });

  testWidgets('quest details scroll above navigation on a short window', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(568, 320);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: QuestScreen(onBack: () {}),
      ),
    );
    final footer = find.byTooltip('Trang chủ');
    final footerBefore = tester.getCenter(footer);
    final status = find.text('Đang thực hiện');
    await tester.ensureVisible(status);
    await tester.pumpAndSettle();
    expect(status.hitTestable(), findsOneWidget);
    expect(tester.getCenter(footer), footerBefore);
    expect(tester.takeException(), isNull);
  });
}

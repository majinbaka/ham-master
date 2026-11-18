import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/pixel_rpg_app.dart';
import 'package:pixel_rpg/app/router/app_router.dart';
import 'package:pixel_rpg/app/presentation/menu_button.dart';
import 'package:pixel_rpg/features/home/presentation/home_footer.dart';

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  expect(target.hitTestable(), findsOneWidget);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  for (final (size, scale) in [
    (const Size(320, 568), 1.0),
    (const Size(844, 390), 2.0),
  ]) {
    testWidgets(
      'Home actions and shortcuts work at $size with ${scale}x text',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(const ProviderScope(child: PixelRpgApp()));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();
        final router = ProviderScope.containerOf(
          tester.element(find.byType(PixelRpgApp)),
        ).read(appRouterProvider);
        final uri = router.routeInformationProvider;

        final dialogue = find.byType(HomeDialogue);
        expect(find.text('Chào mừng, nhà lữ hành!'), findsOneWidget);
        String? previousMessage;
        for (final (label, message) in [
          ('Nói chuyện', 'Người gác làng: Hãy ghé trại gần cổng làng.'),
          ('Quan sát', 'Ánh đèn ven đường dẫn về phía cổng làng.'),
          ('Tìm kiếm', 'Chưa thấy vật phẩm quanh trại.'),
        ]) {
          final target = find.byTooltip(label);
          expect(tester.getSize(target).shortestSide, greaterThanOrEqualTo(48));
          await _tap(tester, target);
          final text = find.descendant(
            of: dialogue,
            matching: find.text(message),
          );
          expect(text.hitTestable(), findsOneWidget);
          expect(find.text('Chào mừng, nhà lữ hành!'), findsNothing);
          if (previousMessage != null) {
            expect(find.text(previousMessage), findsNothing);
          }
          expect(find.byType(AlertDialog), findsNothing);
          expect(uri.value.uri.path, '/home');
          previousMessage = message;
        }

        expect(find.text('BẢN ĐỒ'), findsNothing);

        await _tap(tester, find.byTooltip('Hộp thư'));
        expect(find.widgetWithText(AlertDialog, 'Hộp thư'), findsOneWidget);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(uri.value.uri.path, '/home');

        for (final (label, tab, emptyMessage) in [
          ('Mở Nhiệm vụ phụ', 'side', 'Chưa có nhiệm vụ phụ.'),
          ('Nhiệm vụ hàng ngày', 'daily', 'Chưa có nhiệm vụ hàng ngày.'),
        ]) {
          await _tap(tester, find.byTooltip(label));
          expect(uri.value.uri.toString(), '/home/quests?tab=$tab');
          expect(find.text(emptyMessage), findsOneWidget);
          await _tap(tester, find.byTooltip('Quay lại'));
        }

        await _tap(tester, find.byTooltip('Nhiệm vụ'));
        await _tap(tester, find.widgetWithText(MenuButton, 'Thành tựu'));
        await _tap(tester, find.text('Bước chân đầu'));
        expect(find.byType(AlertDialog), findsOneWidget);
        await _tap(tester, find.text('Đóng'));
        await _tap(tester, find.widgetWithText(MenuButton, 'Chính truyện'));
        await _tap(tester, find.text('3 chương đã khóa'));
        await _tap(tester, find.text('Chương 2\nBên kia đồi\nĐã khóa'));
        expect(
          find.textContaining('Hoàn thành nhiệm vụ chương 1'),
          findsOneWidget,
        );
        await _tap(tester, find.text('Đóng'));
        await _tap(tester, find.text('Vàng\n100'));
        expect(find.textContaining('Phần thưởng mẫu: 100'), findsOneWidget);
        await _tap(tester, find.text('Đóng'));
        expect(find.text('Mục tiêu · 1 / 3'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('locked story explains its requirement and stays locked', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PixelRpgApp()));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await _tap(tester, find.byTooltip('Cốt truyện'));
    await _tap(tester, find.text('2. Dấu vết bên đường · Đã khóa'));
    expect(find.textContaining('Xem xong đoạn truyện 1'), findsOneWidget);
    await _tap(tester, find.text('Đóng'));
    expect(find.text('2. Dấu vết bên đường · Đã khóa'), findsOneWidget);
    expect(find.text('Tiến độ chương · 0 / 5'), findsOneWidget);
  });
}

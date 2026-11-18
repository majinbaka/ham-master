import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/beasts/presentation/beast_screen.dart';

void main() {
  testWidgets('roster filters, sorts and opens the matching beast detail', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: BeastScreen(onNavigate: (_) {}, onBattle: () {}),
      ),
    );

    Future<void> tap(Finder control) async {
      await tester.ensureVisible(control);
      await tester.pumpAndSettle();
      await tester.tap(control);
      await tester.pumpAndSettle();
    }

    await tap(find.text('Bộ lọc'));
    await tap(find.text('Thủy'));
    expect(find.byTooltip('Hỏa Hổ\nCấp 12'), findsNothing);
    expect(find.byTooltip('Hồ Băng\nCấp 10'), findsOneWidget);

    await tap(find.text('Sắp xếp'));
    final bird = find.byTooltip('Chim Lam\nCấp 7');
    final slime = find.byTooltip('Giọt Lam\nCấp 5');
    final birdPosition = tester.getTopLeft(bird);
    final slimePosition = tester.getTopLeft(slime);
    expect(
      birdPosition.dy < slimePosition.dy ||
          (birdPosition.dy == slimePosition.dy &&
              birdPosition.dx < slimePosition.dx),
      isTrue,
    );
    await tap(bird);
    expect(find.text('Chim Lam').hitTestable(), findsOneWidget);
    await tap(find.text('Yêu thích'));
    await tap(find.text('Chỉ yêu thích'));
    expect(find.byTooltip('Hồ Băng\nCấp 10'), findsNothing);
    expect(bird, findsOneWidget);

    await tap(find.text('Chỉ yêu thích'));
    await tap(find.text('Mọi hệ'));
    await tap(find.text('Bộ sưu tầm'));
    await tap(find.byTooltip('Sói Bóng Đêm\nCấp 14'));
    expect(find.text('Chưa thu thập'), findsOneWidget);
    await tap(find.text('Chi tiết'));
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('HP 52 · ATK 29'), findsOneWidget);
  });
}

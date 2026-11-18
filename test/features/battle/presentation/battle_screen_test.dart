import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_button.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/battle/presentation/battle_screen.dart';

void main() {
  testWidgets('battle preview selects a move and target, then pauses', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: BattleScreen(onNavigate: (_) {}, onBack: () {}),
      ),
    );

    Future<void> tap(Finder control) async {
      await tester.ensureVisible(control);
      await tester.pumpAndSettle();
      await tester.tap(control);
      await tester.pumpAndSettle();
    }

    final claw = find.widgetWithText(MenuButton, 'Cào Xé');
    final target = find.byTooltip('Chọn Sói Bóng Đêm làm mục tiêu');

    await tap(find.text('Tốc độ ×1'));
    expect(find.text('Tốc độ ×2'), findsOneWidget);
    await tap(find.text('Tự động'));
    expect(
      tester
          .widget<MenuButton>(find.widgetWithText(MenuButton, 'Tự động'))
          .selected,
      isTrue,
    );
    await tap(claw);
    expect(tester.widget<MenuButton>(claw).selected, isTrue);
    await tap(target);
    expect(find.text('Mục tiêu: Sói Bóng Đêm · Cào Xé'), findsOneWidget);
    await tap(find.text('Tạm dừng'));
    expect(tester.widget<MenuButton>(claw).onPressed, isNull);
    expect(find.text('Đang tạm dừng bản xem thử.'), findsOneWidget);
    await tap(find.text('Tiếp tục'));
    expect(tester.widget<MenuButton>(claw).onPressed, isNotNull);
    expect(find.text('HP 38 / 38'), findsOneWidget);
    expect(find.text('HP 52 / 52'), findsOneWidget);
  });
}

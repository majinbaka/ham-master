import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_button.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/battle/presentation/battle_screen.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('battle fills $size with visible controls at ${scale}x', (
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
            home: BattleScreen(onBack: () {}),
          ),
        );

        final arena = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/scenes/forest-arena.png',
        );
        expect(tester.getSize(arena), size);
        expect(find.byType(Scrollable), findsNothing);
        expect(find.text('HP 38 / 38').hitTestable(), findsOneWidget);
        expect(find.text('HP 52 / 52').hitTestable(), findsOneWidget);
        expect(find.textContaining('Cấp'), findsNothing);
        expect(find.textContaining('Sói Bóng Đêm'), findsNothing);
        expect(find.textContaining('Đợt'), findsNothing);
        expect(find.byTooltip('Tự động'), findsNothing);
        expect(find.byTooltip('Tạm dừng'), findsNothing);
        expect(find.byTooltip('Tăng Tốc'), findsNothing);
        expect(find.textContaining('Tốc độ'), findsNothing);

        for (final label in [
          'Quay lại',
          'Bùng Lửa',
          'Hơi Nóng',
          'Cào Xé',
          'Đánh đối thủ',
        ]) {
          final control = find.byTooltip(label);
          expect(control.hitTestable(), findsOneWidget);
          expect(
            tester.getSize(control).shortestSide,
            greaterThanOrEqualTo(48),
          );
        }

        final claw = find.byTooltip('Cào Xé');
        await tester.tap(claw);
        await tester.pump();
        expect(
          tester
              .widget<MenuButton>(
                find.ancestor(of: claw, matching: find.byType(MenuButton)),
              )
              .selected,
          isTrue,
        );
        await tester.tap(find.byTooltip('Đánh đối thủ'));
        await tester.pump();
        expect(
          find.bySemanticsLabel(RegExp('Cào Xé trúng mục tiêu')),
          findsOneWidget,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}

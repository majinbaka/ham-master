import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_button.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_icon.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';

void main() {
  testWidgets('content cards expose their names before interaction', (
    tester,
  ) async {
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: MenuButton(
            label: 'Chương 1\nKhởi hành',
            icon: PixelIconKind.story,
            showLabel: true,
            onPressed: () => opened = true,
          ),
        ),
      ),
    );
    expect(find.text('Chương 1\nKhởi hành'), findsOneWidget);
    await tester.tap(find.text('Chương 1\nKhởi hành'));
    expect(opened, isTrue);
  });

  testWidgets(
    'icon controls show artwork and retain an accessible action name',
    (tester) async {
      var taps = 0;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: Scaffold(
            body: Center(
              child: MenuButton(
                label: 'Mở túi',
                icon: PixelIconKind.backpack,
                selected: true,
                onPressed: () => taps++,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Mở túi'), findsNothing);
      expect(find.byTooltip('Mở túi'), findsOneWidget);
      expect(find.bySemanticsLabel('Mở túi'), findsOneWidget);
      expect(tester.widget<PixelIcon>(find.byType(PixelIcon)).size, 36);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      await tester.tap(find.byTooltip('Mở túi'));
      expect(taps, 1);
      await tester.longPress(find.byTooltip('Mở túi'));
      await tester.pumpAndSettle();
      expect(find.text('Mở túi'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      semantics.dispose();
    },
  );
}

import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_button.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_frame.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_icon.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';

void main() {
  testWidgets('enabled buttons stand out from their matching panels', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: Column(
            children: [
              for (final skin in PixelFrameSkin.values)
                MenuButton(
                  label: skin.name,
                  skin: skin,
                  selected: skin == PixelFrameSkin.selected,
                  onPressed: () {},
                ),
            ],
          ),
        ),
      ),
    );

    final fills = <Color>{};
    for (final skin in PixelFrameSkin.values) {
      final button = tester.widget<TextButton>(
        find.widgetWithText(TextButton, skin.name),
      );
      final style = button.style!;
      final fill = style.backgroundColor!.resolve({})!;
      final foreground = style.foregroundColor!.resolve({})!;
      final edge = style.shape!.resolve({})!.side.color;
      expect(fill.a, 1, reason: skin.name);
      expect(fill, isNot(skin.background), reason: skin.name);
      expect(_contrast(foreground, fill), greaterThanOrEqualTo(4.5));
      expect(_contrast(edge, fill), greaterThanOrEqualTo(3));
      expect(_contrast(edge, skin.background), greaterThanOrEqualTo(3));
      fills.add(fill);
    }
    expect(fills, hasLength(PixelFrameSkin.values.length));
  });

  testWidgets('tabs keep a 48 dp touch target around a compact frame', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: Scaffold(
          body: Center(
            child: MenuButton.tab(
              label: 'Âm thanh',
              selected: true,
              onPressed: () => taps++,
            ),
          ),
        ),
      ),
    );

    final button = find.byType(TextButton);
    final frame = find.descendant(of: button, matching: find.byType(Material));
    expect(tester.getSize(frame).height, 40);
    final target = tester.getRect(button);
    expect(target.height, 48);
    expect(target.width, greaterThanOrEqualTo(48));
    final edge = target.topCenter + const Offset(0, 1);
    expect(tester.getRect(frame).contains(edge), isFalse);
    await tester.tapAt(edge);
    expect(taps, 1);
  });

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
      expect(find.byIcon(Icons.check_circle), findsNothing);
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Mở túi'))
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(
        button.style!.backgroundColor!.resolve({}),
        PixelFrameSkin.selected.buttonBackground,
      );
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

double _contrast(Color dark, Color light) =>
    (light.computeLuminance() + 0.05) / (dark.computeLuminance() + 0.05);

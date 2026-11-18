// Run: flutter test tool/preview_ui_test.dart
// Review PNGs, not golden assertions: these are portable layout references.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_button.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/battle/presentation/battle_screen.dart';
import 'package:pixel_rpg/features/beasts/presentation/beast_screen.dart';
import 'package:pixel_rpg/features/home/presentation/home_screen.dart';
import 'package:pixel_rpg/features/launch/presentation/launch_screen.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';
import 'package:pixel_rpg/features/settings/presentation/settings_screen.dart';
import 'package:pixel_rpg/features/shop/presentation/shop_screen.dart';

import 'preview_modal_cases.dart';

void main() {
  testWidgets('render UI review references', (tester) async {
    final font = FontLoader('GameRoboto');
    for (final weight in ['Regular', 'Medium', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/Roboto-$weight.ttf'));
    }
    await font.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const screen = String.fromEnvironment('SCREEN');
    final selectedScreens = screen.split(',');
    const extended = bool.fromEnvironment('EXTENDED');
    const output = String.fromEnvironment(
      'OUTPUT',
      defaultValue: 'docs/art/runtime-preview',
    );
    for (final size in [
      const Size(390, 844),
      if (extended) ...[
        const Size(320, 568),
        const Size(844, 390),
        const Size(1440, 900),
      ],
    ]) {
      tester.view.physicalSize = size;
      for (final scale in [1.0, if (extended) 2.0]) {
        final home = HomeScreen(onOpenBattle: () {}, onNavigate: (_) {});
        final screens = <String, Widget>{
          'home': home,
          'home-talk': home,
          'shop': ShopScreen(onNavigate: (_) {}),
          'beasts': BeastScreen(onNavigate: (_) {}, onBattle: () {}),
          'battle': BattleScreen(onBack: () {}),
          'profile': ProfileScreen(onNavigate: (_) {}),
          'settings': SettingsScreen(onNavigate: (_) {}),
          'launch': LaunchScreen(onComplete: () {}),
        };
        final captureModals = size == const Size(390, 844) && scale == 1;
        for (final (name, widget, steps) in [
          for (final entry in screens.entries)
            (entry.key, entry.value, const <String>[]),
          if (captureModals)
            for (final group in previewModalCases.entries)
              for (final modal in group.value.entries)
                (
                  'modals/${group.key}-${modal.key}',
                  screens[group.key]!,
                  modal.value,
                ),
        ]) {
          if (screen.isNotEmpty && !selectedScreens.contains(name)) continue;
          final key = GlobalKey();
          await tester.pumpWidget(
            RepaintBoundary(
              key: key,
              child: MaterialApp(
                theme: appTheme,
                debugShowCheckedModeBanner: false,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!,
                ),
                home: widget,
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 1500));
          await tester.runAsync(() async {
            // PixelIcon paints an atlas directly rather than using Image widgets.
            await precacheImage(
              const AssetImage('assets/ui/icon-atlas.png'),
              key.currentContext!,
            );
            for (final element in find.byType(Image).evaluate()) {
              await precacheImage((element.widget as Image).image, element);
            }
          });
          await tester.pump();
          for (final step in steps) {
            final button = find.widgetWithText(MenuButton, step);
            final text = find.text(step);
            final control = button.evaluate().isNotEmpty
                ? button
                : text.evaluate().isNotEmpty
                ? text
                : find.byTooltip(step);
            await tester.ensureVisible(control);
            await tester.pumpAndSettle();
            expect(
              control.hitTestable(),
              findsOneWidget,
              reason: '$name · $step',
            );
            await tester.tap(control);
            await tester.pumpAndSettle();
          }
          if (steps.isNotEmpty) {
            expect(find.byType(AlertDialog), findsOneWidget, reason: name);
          }
          if (name == 'home-talk') {
            final talk = find.byTooltip('Nói chuyện');
            await tester.ensureVisible(talk);
            await tester.pumpAndSettle();
            await tester.tap(talk);
            await tester.pumpAndSettle();
            expect(
              find
                  .text('Người gác làng: Hãy ghé trại gần cổng làng.')
                  .hitTestable(),
              findsOneWidget,
            );
            expect(find.byType(AlertDialog), findsNothing);
          }
          expect(tester.takeException(), isNull);
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final suffix = size == const Size(390, 844) && scale == 1
              ? ''
              : '-${size.width.toInt()}x${size.height.toInt()}-${scale.toInt()}x';
          await tester.runAsync(() async {
            final image = await boundary.toImage();
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            final file = File('$output/$name$suffix.png');
            await file.parent.create(recursive: true);
            await file.writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    }
  });
}

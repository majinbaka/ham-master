// Run: flutter test tool/preview_ui_test.dart --update-goldens
// Review PNGs, not golden assertions: these are portable layout references.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/home/presentation/home_screen.dart';
import 'package:pixel_rpg/features/launch/presentation/launch_screen.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';
import 'package:pixel_rpg/features/quests/presentation/quest_screen.dart';
import 'package:pixel_rpg/features/settings/presentation/settings_screen.dart';
import 'package:pixel_rpg/features/shop/presentation/shop_screen.dart';
import 'package:pixel_rpg/features/story/presentation/story_screen.dart';

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
        for (final entry in <String, Widget>{
          'home': HomeScreen(onOpenQuests: () {}),
          'story': StoryScreen(onNavigate: (_) {}, onStart: () {}),
          'episode': StoryEpisodeScreen(onBack: () {}),
          'quests': QuestScreen(onBack: () {}),
          'shop': ShopScreen(onNavigate: (_) {}),
          'profile': ProfileScreen(onNavigate: (_) {}),
          'settings': SettingsScreen(onNavigate: (_) {}),
          'launch': LaunchScreen(onComplete: () {}),
        }.entries) {
          if (screen.isNotEmpty && screen != entry.key) continue;
          final key = GlobalKey();
          await tester.pumpWidget(
            MaterialApp(
              theme: appTheme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: RepaintBoundary(key: key, child: entry.value),
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
            final file = File('$output/${entry.key}$suffix.png');
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

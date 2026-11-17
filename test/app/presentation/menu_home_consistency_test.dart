import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/game_chrome_layout.dart';
import 'package:pixel_rpg/app/presentation/menu_panel.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_art_scale.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_frame.dart';
import 'package:pixel_rpg/app/presentation/pixel_navigation.dart';
import 'package:pixel_rpg/app/presentation/player_hud.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/app/theme/game_typography.dart';
import 'package:pixel_rpg/features/home/presentation/home_screen.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';
import 'package:pixel_rpg/features/quests/presentation/quest_screen.dart';
import 'package:pixel_rpg/features/settings/presentation/settings_screen.dart';
import 'package:pixel_rpg/features/shop/presentation/shop_screen.dart';
import 'package:pixel_rpg/features/story/presentation/story_screen.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    for (final textScale in [1.0, 2.0]) {
      testWidgets(
        'menus match Home anchors and density at $size / $textScale',
        (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          Future<void> show(Widget screen, String name) => tester.pumpWidget(
            MaterialApp(
              key: ValueKey(name),
              theme: appTheme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(textScale)),
                child: child!,
              ),
              home: screen,
            ),
          );
          await show(HomeScreen(onNavigate: (_) {}), 'home');
          // The two projection paths may differ below 1e-6 dp due to doubles.
          final homeLabel = tester.widget<Text>(
            find.text('Cấp —   Nhà lữ hành'),
          );
          final homeStyle = DefaultTextStyle.of(
            tester.element(find.text('Cấp —   Nhà lữ hành')),
          ).style.merge(homeLabel.style);
          expect(homeStyle.fontFamily, GameTypography.family);
          final nav = tester.getRect(find.byType(PixelNavigation));
          final profile = tester.getRect(find.byType(PlayerHud));
          final resources = tester.getRect(find.byType(ResourceHud));
          for (final (name, screen) in <(String, Widget)>[
            ('story', StoryScreen(onNavigate: (_) {}, onStart: () {})),
            ('shop', ShopScreen(onNavigate: (_) {})),
            ('profile', ProfileScreen(onNavigate: (_) {})),
            ('settings', SettingsScreen(onNavigate: (_) {})),
            ('quests', QuestScreen(onBack: () {})),
            ('episode', StoryEpisodeScreen(onBack: () {})),
          ]) {
            await show(screen, name);
            expect(
              tester.getRect(find.byType(PlayerHud)),
              rectMoreOrLessEquals(profile, epsilon: 0.000001),
              reason: name,
            );
            expect(
              tester.getRect(find.byType(ResourceHud)),
              rectMoreOrLessEquals(resources, epsilon: 0.000001),
              reason: name,
            );
            expect(
              tester.getRect(find.byType(PixelNavigation)),
              rectMoreOrLessEquals(nav, epsilon: 0.000001),
              reason: name,
            );
            final menuText = find
                .descendant(
                  of: find.byType(MenuPanel).first,
                  matching: find.byType(Text),
                )
                .first;
            final menuStyle = DefaultTextStyle.of(
              tester.element(menuText),
            ).style.merge(tester.widget<Text>(menuText).style);
            expect(menuStyle.fontFamily, homeStyle.fontFamily, reason: name);
            final panelFrame = find
                .descendant(
                  of: find.byType(MenuPanel).first,
                  matching: find.byType(PixelFrame),
                )
                .first;
            expect(
              PixelArtScale.of(tester.element(panelFrame)),
              GameChromeLayout(size).scale,
            );
            expect(PixelArtScale.of(tester.element(find.byType(PlayerHud))), 1);
            await tester.drag(
              find.byKey(const ValueKey('menu-content')),
              const Offset(0, -2000),
            );
            await tester.pumpAndSettle();
            expect(
              tester.getRect(find.byType(PlayerHud)),
              rectMoreOrLessEquals(profile, epsilon: 0.000001),
              reason: name,
            );
            expect(
              tester.getRect(find.byType(ResourceHud)),
              rectMoreOrLessEquals(resources, epsilon: 0.000001),
              reason: name,
            );
            expect(
              tester.getRect(find.byType(PixelNavigation)),
              rectMoreOrLessEquals(nav, epsilon: 0.000001),
              reason: name,
            );
            expect(tester.takeException(), isNull, reason: name);
          }
        },
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_panel.dart';
import 'package:pixel_rpg/app/presentation/artwork_projection.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_frame.dart';
import 'package:pixel_rpg/app/presentation/pixel_navigation.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/app/theme/game_typography.dart';
import 'package:pixel_rpg/features/home/presentation/home_screen.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';
import 'package:pixel_rpg/features/settings/presentation/settings_screen.dart';
import 'package:pixel_rpg/features/shop/presentation/shop_screen.dart';

double renderedFontSize(WidgetTester tester, Finder text) {
  final paragraph = tester.renderObject<RenderParagraph>(
    find.descendant(of: text, matching: find.byType(RichText)),
  );
  final size = paragraph.text.style!.fontSize!;
  return paragraph.textScaler.scale(size) *
      paragraph.getTransformTo(null).getMaxScaleOnAxis();
}

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
          final homeBodySize = renderedFontSize(
            tester,
            find.text('Chào mừng, nhà lữ hành!'),
          );
          final homeTitleSize = renderedFontSize(
            tester,
            find.text('Pixel RPG'),
          );
          expect(homeBodySize, closeTo(17 * textScale, 0.001));
          expect(homeTitleSize, closeTo(16 * textScale, 0.001));
          expect(find.text('Cấp —   Nhà lữ hành'), findsNothing);
          expect(find.text('—'), findsNothing);
          final nav = tester.getRect(find.byType(PixelNavigation));
          for (final (name, screen) in <(String, Widget)>[
            ('shop', ShopScreen(onNavigate: (_) {})),
            ('profile', ProfileScreen(onNavigate: (_) {})),
            ('settings', SettingsScreen(onNavigate: (_) {})),
          ]) {
            await show(screen, name);
            expect(find.text('Cấp —   Nhà lữ hành'), findsNothing);
            expect(find.text('—'), findsNothing);
            expect(
              tester.getRect(find.byType(PixelNavigation)),
              rectMoreOrLessEquals(nav, epsilon: 0.000001),
              reason: name,
            );
            final menuText = name == 'profile'
                ? find.text('ID mẫu: 1004527')
                : find
                      .descendant(
                        of: find.byType(MenuPanel).first,
                        matching: find.byType(Text),
                      )
                      .first;
            final menuStyle = DefaultTextStyle.of(
              tester.element(menuText),
            ).style.merge(tester.widget<Text>(menuText).style);
            expect(menuStyle.fontFamily, GameTypography.family, reason: name);
            expect(
              renderedFontSize(tester, menuText),
              closeTo(homeBodySize, 0.001),
              reason: '$name body',
            );
            final panel = tester.widget<MenuPanel>(
              find.byType(MenuPanel).first,
            );
            expect(
              renderedFontSize(
                tester,
                find
                    .descendant(
                      of: find.byType(MenuPanel).first,
                      matching: find.text(panel.title!),
                    )
                    .last,
              ),
              closeTo(homeTitleSize, 0.001),
              reason: '$name panel title',
            );
            final panelFrame = find
                .descendant(
                  of: find.byType(MenuPanel).first,
                  matching: find.byType(PixelFrame),
                )
                .first;
            expect(ArtworkProjection.of(tester.element(panelFrame)), 1);
            await tester.drag(
              find.byKey(const ValueKey('menu-content')),
              const Offset(0, -2000),
            );
            await tester.pumpAndSettle();
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

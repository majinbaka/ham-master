import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/pixel_rpg_app.dart';
import 'package:pixel_rpg/app/router/app_router.dart';
import 'package:pixel_rpg/app/presentation/menu_components.dart';
import 'package:pixel_rpg/app/presentation/menu_shell.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/battle/presentation/battle_screen.dart';
import 'package:pixel_rpg/features/beasts/presentation/beast_screen.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';
import 'package:pixel_rpg/features/settings/presentation/settings_screen.dart';
import 'package:pixel_rpg/features/shop/presentation/shop_screen.dart';

import '../support/profile_card_test_scope.dart';

void main() {
  testWidgets('remaining menus navigate through real routes', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(withProfileCard(const PixelRpgApp()));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    final router = ProviderScope.containerOf(
      tester.element(find.byType(PixelRpgApp)),
    ).read(appRouterProvider);
    for (final (label, path) in [
      ('Cửa hàng', 'shop'),
      ('Hồ sơ', 'profile'),
      ('Cài đặt', 'settings'),
      ('Trang chủ', ''),
    ]) {
      await tester.tap(find.byTooltip(label).last);
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        path.isEmpty ? '/home' : '/home/$path',
      );
      expect(tester.takeException(), isNull);
    }
    for (final path in ['/home/story', '/home/story/episode', '/home/quests']) {
      expect(router.configuration.findMatch(Uri.parse(path)).isError, isTrue);
    }
  });

  testWidgets('home and beasts open battle through real routes', (
    tester,
  ) async {
    await tester.pumpWidget(withProfileCard(const PixelRpgApp()));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    Future<void> tap(String label) async {
      final control = find.byTooltip(label);
      await tester.ensureVisible(control);
      await tester.pumpAndSettle();
      await tester.tap(control);
      await tester.pumpAndSettle();
    }

    await tap('Trận chiến');
    expect(find.byType(BattleScreen), findsOneWidget);
    await tap('Quay lại');
    expect(find.byTooltip('Trận chiến').hitTestable(), findsOneWidget);

    await tap('Hồ sơ');
    await tap('Mở danh sách yêu thú');
    expect(find.byType(BeastScreen), findsOneWidget);
    await tap('Hồ Băng\nCấp 10');
    await tap('Xem thử trận chiến');
    expect(find.byType(BattleScreen), findsOneWidget);
    await tap('Quay lại');
    expect(find.text('Hồ Băng'), findsOneWidget);
    await tap('Về Hồ sơ');
    expect(find.byType(ProfileScreen), findsOneWidget);

    final router = ProviderScope.containerOf(
      tester.element(find.byType(PixelRpgApp)),
    ).read(appRouterProvider);
    router.go('/home/battle');
    await tester.pumpAndSettle();
    expect(find.byType(BattleScreen), findsOneWidget);
    await tap('Quay lại');
    expect(router.routeInformationProvider.value.uri.path, '/home');
  });

  testWidgets('shop filters and opens details without purchasing', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: ShopScreen(onNavigate: (_) {})));
    await tester.tap(find.text('Trang bị'));
    await tester.pumpAndSettle();
    expect(
      find.byTooltip('Thuốc hồi phục\n120 ngọc\nXem chi tiết'),
      findsNothing,
    );
    await tester.ensureVisible(
      find.byTooltip('Kiếm tập luyện\n300 vàng\nXem chi tiết'),
    );
    await tester.tap(find.byTooltip('Kiếm tập luyện\n300 vàng\nXem chi tiết'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('Chưa thực hiện giao dịch'), findsOneWidget);
    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('settings show only account, general and information tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: SettingsScreen(onNavigate: (_) {})),
    );
    final tabs = find.descendant(
      of: find.byType(MenuColumns),
      matching: find.byType(MenuButton),
    );
    expect(tester.widgetList<MenuButton>(tabs).map((button) => button.label), [
      'Tài khoản',
      'Chung',
      'Thông tin',
    ]);
    expect(tester.widget<MenuButton>(tabs.first).selected, isTrue);
    expect(find.textContaining('Chế độ xem trước offline'), findsOneWidget);

    await tester.tap(find.widgetWithText(MenuButton, 'Thông tin'));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(MenuButton, 'Giới thiệu PixelRPG'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(MenuButton, 'Chung'));
    await tester.pumpAndSettle();
    final slider = find.byType(Slider).first;
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(-70, 0));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(slider).value, lessThan(80));
    final toggle = find.descendant(
      of: find.widgetWithText(SwitchListTile, 'Hiện vùng tương tác'),
      matching: find.byType(Switch),
    );
    expect(tester.widget<Switch>(toggle).value, isTrue);
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isFalse);
    await tester.tap(find.text('Hiện vùng tương tác'));
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings reset can be canceled or confirmed', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: SettingsScreen(onNavigate: (_) {}),
      ),
    );
    await tester.tap(find.widgetWithText(MenuButton, 'Chung'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('D-Pad'));
    await tester.tap(find.text('D-Pad'));
    await tester.pumpAndSettle();

    for (final action in ['Hủy', 'Khôi phục']) {
      final reset = find.text('Khôi phục mặc định');
      await tester.ensureVisible(reset);
      await tester.pumpAndSettle();
      await tester.tap(reset);
      await tester.pumpAndSettle();
      expect(find.text('Khôi phục mặc định?'), findsOneWidget);
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
      final touch = tester.widget<MenuButton>(
        find.widgetWithText(MenuButton, 'Chạm'),
      );
      expect(touch.selected, action == 'Khôi phục');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile tabs open collection and badge descriptions', (
    tester,
  ) async {
    await tester.pumpWidget(
      withProfileCard(
        MaterialApp(
          theme: appTheme,
          home: ProfileScreen(onNavigate: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Trang sách mới'), findsNothing);
    for (final (tab, item, description) in [
      ('Sổ sưu tầm', 'Trang sách mới', 'Trang mở đầu'),
      ('Huy hiệu', 'Người khám phá', 'ghé thăm các địa điểm'),
    ]) {
      final tabButton = find.widgetWithText(MenuButton, tab);
      await tester.ensureVisible(tabButton);
      await tester.tap(tabButton);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(item));
      await tester.tap(find.text(item));
      await tester.pumpAndSettle();
      expect(find.textContaining(description), findsOneWidget);
      await tester.tap(find.text('Đóng'));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    for (final scale in [1.0, 2.0]) {
      for (final screen in ['shop', 'profile', 'settings', 'beasts']) {
        testWidgets(
          '$screen fits $size at text scale $scale and keeps navigation visible',
          (tester) async {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);
            final child = switch (screen) {
              'shop' => ShopScreen(onNavigate: (_) {}),
              'profile' => ProfileScreen(onNavigate: (_) {}),
              'beasts' => BeastScreen(onNavigate: (_) {}, onBattle: () {}),
              _ => SettingsScreen(onNavigate: (_) {}),
            };
            await tester.pumpWidget(
              withProfileCard(
                MaterialApp(
                  theme: appTheme,
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: TextScaler.linear(scale)),
                    child: child!,
                  ),
                  home: child,
                ),
              ),
            );
            await tester.pumpAndSettle();
            final navigation = find.byTooltip('Trang chủ');
            final position = tester.getCenter(navigation);
            await tester.drag(
              find.byType(SingleChildScrollView).first,
              const Offset(0, -2000),
            );
            await tester.pumpAndSettle();
            expect(tester.getCenter(navigation), position);
            expect(navigation.hitTestable(), findsOneWidget);
            expect(find.byType(MenuShell), findsOneWidget);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}

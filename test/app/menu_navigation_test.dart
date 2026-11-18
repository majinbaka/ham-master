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
import 'package:pixel_rpg/features/quests/presentation/quest_screen.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';
import 'package:pixel_rpg/features/settings/presentation/settings_screen.dart';
import 'package:pixel_rpg/features/shop/presentation/shop_screen.dart';
import 'package:pixel_rpg/features/story/presentation/story_screen.dart';

void main() {
  testWidgets('menus navigate through real routes and preview an episode', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: PixelRpgApp()));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    final router = ProviderScope.containerOf(
      tester.element(find.byType(PixelRpgApp)),
    ).read(appRouterProvider);
    for (final (label, path) in [
      ('Cốt truyện', 'story'),
      ('Cửa hàng', 'shop'),
      ('Hồ sơ', 'profile'),
      ('Cài đặt', 'settings'),
      ('Nhiệm vụ', 'quests'),
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
    await tester.tap(find.byTooltip('Cốt truyện'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Bắt đầu xem thử'));
    await tester.tap(find.text('Bắt đầu xem thử'));
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      '/home/story/episode',
    );
    await tester.tap(find.byTooltip('Về Cốt truyện'));
    await tester.pumpAndSettle();
    expect(find.text('Tiến độ chương · 0 / 5'), findsOneWidget);
  });

  testWidgets('home, beasts and quests open battle through real routes', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PixelRpgApp()));
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

    await tap('Nhiệm vụ');
    await tap('Xem thử trận chiến');
    expect(find.byType(BattleScreen), findsOneWidget);
    await tap('Quay lại');
    expect(find.byType(QuestScreen), findsOneWidget);

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

  testWidgets('settings change only preview controls and switch category', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: SettingsScreen(onNavigate: (_) {})),
    );
    final slider = find.byType(Slider).first;
    await tester.drag(slider, const Offset(-70, 0));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(slider).value, lessThan(80));
    await tester.tap(find.widgetWithText(MenuButton, 'Điều khiển'));
    await tester.pumpAndSettle();
    final toggle = find.byType(Switch).first;
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
    await tester.tap(find.text('Điều khiển'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('D-Pad'));
    await tester.tap(find.text('D-Pad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chung'));
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
      MaterialApp(
        theme: appTheme,
        home: ProfileScreen(onNavigate: (_) {}),
      ),
    );
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
      for (final screen in [
        'story',
        'shop',
        'profile',
        'settings',
        'quests',
        'episode',
        'beasts',
      ]) {
        testWidgets(
          '$screen fits $size at text scale $scale and keeps navigation visible',
          (tester) async {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);
            final child = switch (screen) {
              'story' => StoryScreen(onNavigate: (_) {}, onStart: () {}),
              'shop' => ShopScreen(onNavigate: (_) {}),
              'profile' => ProfileScreen(onNavigate: (_) {}),
              'quests' => QuestScreen(onBack: () {}),
              'episode' => StoryEpisodeScreen(onBack: () {}),
              'beasts' => BeastScreen(onNavigate: (_) {}, onBattle: () {}),
              _ => SettingsScreen(onNavigate: (_) {}),
            };
            await tester.pumpWidget(
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

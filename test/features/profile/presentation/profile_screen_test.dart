import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/beasts/presentation/beast_preview_data.dart';
import 'package:pixel_rpg/features/profile/domain/profile_card.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_showcase_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../support/profile_card_test_scope.dart';

void main() {
  testWidgets(
    'keeps the selected artwork behind the viewport while scrolling',
    (tester) async {
      const size = Size(320, 568);
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 24, bottom: 16);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      await tester.pumpWidget(
        withProfileCard(
          MaterialApp(
            theme: appTheme,
            home: ProfileScreen(onNavigate: (_) {}),
          ),
          store: TestProfileCardStore(
            ProfileCard(
              friendCode: testFriendCode,
              background: ProfileBackground.forest,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final artwork = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image == const AssetImage('assets/scenes/forest-arena.png'),
      );
      final name = find.text('Nhà lữ hành');
      final initialNamePosition = tester.getTopLeft(name);
      expect(tester.getRect(artwork), Offset.zero & size);
      expect(tester.getTopLeft(find.byTooltip('Quay lại')).dy, greaterThan(24));

      await tester.drag(
        find.byKey(const ValueKey('menu-content')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(name).dy, lessThan(initialNamePosition.dy));
      expect(tester.getRect(artwork), Offset.zero & size);
    },
  );

  testWidgets(
    'edits the card, keeps failed drafts and restores saved choices',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final store = TestProfileCardStore(
        ProfileCard(
          friendCode: testFriendCode,
          title: 'Danh hiệu đã lưu',
          bio: 'Giới thiệu đã lưu',
          badges: const {ProfileBadge.explorer},
          showStats: false,
        ),
      );
      Future<void> openProfile() async {
        await tester.pumpWidget(
          withProfileCard(
            MaterialApp(
              theme: appTheme,
              home: ProfileScreen(onNavigate: (_) {}),
            ),
            store: store,
          ),
        );
        await tester.pumpAndSettle();
      }

      Future<void> tap(Finder finder) async {
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      await openProfile();
      await tap(find.byTooltip('Chỉnh sửa thẻ'));
      await tester.enterText(find.byType(TextFormField).first, '   ');
      await tap(find.text('Lưu thẻ'));
      expect(find.text('Nhập tên hiển thị.'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first, '  An  ');
      await tap(find.text('Làng ban ngày'));
      await tap(find.text('Rừng đấu trường').last);
      await tap(find.text('Lữ hành mũ vàng'));
      await tap(find.text('Trinh sát').last);
      await tap(find.text('Hỏa Hổ'));
      await tap(find.text('Hồ Băng').last);
      store.failSave = true;
      await tap(find.text('Lưu thẻ'));
      expect(find.text('Chưa lưu được thẻ. Thử lại.'), findsOneWidget);
      expect(store.card!.name, 'Nhà lữ hành');
      store.failSave = false;
      await tap(find.text('Lưu thẻ'));
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('An'), findsOneWidget);
      expect(find.text('Chỉ số hành trình mẫu'), findsNothing);
      expect(find.text('Người khám phá'), findsNothing);
      expect(find.bySemanticsLabel('Hồ Băng'), findsOneWidget);
      expect(store.card!.background, ProfileBackground.forest);
      expect(store.card!.avatar, ProfileAvatar.scout);
      expect(store.card!.title, 'Danh hiệu đã lưu');
      expect(store.card!.bio, 'Giới thiệu đã lưu');
      expect(store.card!.badges, {ProfileBadge.explorer});
      expect(store.card!.showStats, isFalse);

      await tap(find.byTooltip('Chỉnh sửa thẻ'));
      await tester.enterText(find.byType(TextFormField).first, 'Bản nháp');
      await tap(find.text('Hủy'));
      expect(find.text('An'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await openProfile();
      expect(find.text('An'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Mã QR kết bạn $testFriendCode'),
        findsOneWidget,
      );
    },
  );

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    testWidgets('shows only name, count and QR without scrolling at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const name = 'Nhà lữ hành qua những vì sao';
      await tester.pumpWidget(
        withProfileCard(
          MaterialApp(
            theme: appTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: ProfileScreen(onNavigate: (_) {}),
          ),
          store: TestProfileCardStore(
            ProfileCard(
              friendCode: testFriendCode,
              name: name,
              title: 'Danh hiệu cũ',
              bio: 'Giới thiệu cũ',
              badges: const {ProfileBadge.explorer},
              showStats: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final card = find.byType(ProfileShowcaseCard);
      final copy = find.descendant(of: card, matching: find.byType(Text));
      expect(tester.widgetList<Text>(copy).map((text) => text.data), [
        name,
        '${BeastPreview.owned.length} yêu thú',
      ]);
      final qr = find.byType(QrImageView);
      expect(
        find.bySemanticsLabel('Mã QR kết bạn $testFriendCode'),
        findsOneWidget,
      );

      final viewport = tester.getRect(
        find.byKey(const ValueKey('menu-content')),
      );
      for (final item in [
        find.text(name),
        find.text('${BeastPreview.owned.length} yêu thú'),
        qr,
      ]) {
        final bounds = tester.getRect(item);
        expect(viewport.intersect(bounds), bounds);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'shares the complete card as a PNG over the selected background',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const share = MethodChannel('dev.fluttercommunity.plus/share');
      const paths = MethodChannel('plugins.flutter.io/path_provider');
      final messenger = tester.binding.defaultBinaryMessenger;
      final temp = Directory.systemTemp.createTempSync('profile-share-');
      addTearDown(() {
        messenger.setMockMethodCallHandler(share, null);
        messenger.setMockMethodCallHandler(paths, null);
        temp.deleteSync(recursive: true);
      });
      messenger.setMockMethodCallHandler(paths, (_) async => temp.path);

      await tester.pumpWidget(
        withProfileCard(
          MaterialApp(
            theme: appTheme,
            home: ProfileScreen(onNavigate: (_) {}),
          ),
          store: TestProfileCardStore(
            ProfileCard(
              friendCode: testFriendCode,
              background: ProfileBackground.parchment,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final card = tester.getRect(find.byType(ProfileShowcaseCard));
      final viewport = tester.getRect(
        find.byKey(const ValueKey('menu-content')),
      );
      expect(card.bottom, lessThanOrEqualTo(viewport.bottom));
      await tester.runAsync(() async {
        final shared = Completer<File>();
        messenger.setMockMethodCallHandler(share, (call) async {
          final paths = call.arguments['paths'] as List<Object?>;
          shared.complete(File(paths.single! as String));
          return 'test';
        });
        await tester.tap(find.byTooltip('Chia sẻ ảnh'));
        final file = await shared.future.timeout(const Duration(seconds: 5));
        expect(file.uri.pathSegments.last, 'pixel-rpg-$testFriendCode.png');
        final codec = await ui.instantiateImageCodec(await file.readAsBytes());
        final frame = await codec.getNextFrame();
        try {
          expect(frame.image.width, ((card.width + 16) * 3).ceil());
          expect(frame.image.height, ((card.height + 16) * 3).ceil());
          final pixels = (await frame.image.toByteData())!;
          expect(pixels.getUint8(3), 255);
          expect(pixels.getUint8(0), greaterThan(pixels.getUint8(2)));
        } finally {
          frame.image.dispose();
          codec.dispose();
        }
      });
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}

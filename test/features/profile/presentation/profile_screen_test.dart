import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/profile/domain/profile_card.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_showcase_card.dart';

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
        ProfileCard(friendCode: testFriendCode),
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
      await tap(find.text('Chỉnh sửa thẻ'));
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
      await tap(find.widgetWithText(CheckboxListTile, 'Người khám phá'));
      await tap(find.text('Hiện chỉ số mẫu'));
      store.failSave = true;
      await tap(find.text('Lưu thẻ'));
      expect(find.text('Chưa lưu được thẻ. Thử lại.'), findsOneWidget);
      expect(store.card!.name, 'Nhà lữ hành');
      store.failSave = false;
      await tap(find.text('Lưu thẻ'));
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('An'), findsOneWidget);
      expect(find.text('Chỉ số hành trình mẫu'), findsNothing);
      expect(find.text('Người khám phá'), findsOneWidget);
      expect(find.bySemanticsLabel('Hồ Băng'), findsOneWidget);
      expect(store.card!.background, ProfileBackground.forest);
      expect(store.card!.avatar, ProfileAvatar.scout);
      expect(store.card!.badges, {
        ProfileBadge.firstStep,
        ProfileBadge.explorer,
      });

      await tap(find.text('Chỉnh sửa thẻ'));
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

  testWidgets('copies the exact code printed on the card and in the QR', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = call.arguments['text'] as String;
        }
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
    await tester.pumpWidget(
      withProfileCard(
        MaterialApp(
          theme: appTheme,
          home: ProfileScreen(onNavigate: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final copy = find.byTooltip('Sao chép mã kết bạn');
    await tester.ensureVisible(copy);
    await tester.pumpAndSettle();
    await tester.tap(copy);
    await tester.pumpAndSettle();
    expect(find.text(testFriendCode), findsOneWidget);
    expect(copied, testFriendCode);
    expect(find.bySemanticsLabel('Mã QR kết bạn $copied'), findsOneWidget);
    expect(find.text('Đã sao chép mã kết bạn.'), findsOneWidget);
  });
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
      expect(card.bottom, greaterThan(viewport.bottom));
      await tester.runAsync(() async {
        final shared = Completer<File>();
        messenger.setMockMethodCallHandler(share, (call) async {
          final paths = call.arguments['paths'] as List<Object?>;
          shared.complete(File(paths.single! as String));
          return 'test';
        });
        await tester.tap(find.text('Chia sẻ ảnh'));
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

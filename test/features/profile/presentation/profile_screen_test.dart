import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/profile/domain/profile_card.dart';
import 'package:pixel_rpg/features/profile/presentation/profile_screen.dart';

import '../../../support/profile_card_test_scope.dart';

void main() {
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
}

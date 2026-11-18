import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';
import 'package:pixel_rpg/features/home/presentation/home_screen.dart';
import 'package:pixel_rpg/features/home/presentation/home_layout.dart';
import 'package:pixel_rpg/app/presentation/game_spacing.dart';
import 'package:pixel_rpg/features/home/presentation/home_footer.dart';
import 'package:pixel_rpg/features/home/presentation/home_overview.dart';
import 'package:pixel_rpg/app/presentation/pixel/pixel_icon.dart';

void main() {
  testWidgets('keeps reference groups visible and navigation on one row', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: appTheme, home: const HomeScreen()),
    );

    expect(find.text('BẢN ĐỒ'), findsNothing);
    expect(find.byType(SingleChildScrollView), findsNothing);
    final home = tester.getCenter(find.byTooltip('Trang chủ'));
    final story = tester.getCenter(find.byTooltip('Cốt truyện'));
    expect(story.dy, closeTo(home.dy, 0.1));
    expect(story.dx, greaterThan(home.dx));
    expect(tester.takeException(), isNull);
  });

  testWidgets('centers button content and uses equal action gaps', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: appTheme, home: const HomeScreen()),
    );
    final frames = find.descendant(
      of: find.byType(HomeActions),
      matching: find.byType(TextButton),
    );
    expect(frames, findsNWidgets(3));
    final rects = <Rect>[];
    for (final frame in frames.evaluate()) {
      final finder = find.byWidget(frame.widget);
      final rect = tester.getRect(finder);
      rects.add(rect);
      final icon = find.descendant(
        of: finder,
        matching: find.byType(PixelIcon),
      );

      expect(tester.getCenter(icon).dx, closeTo(rect.center.dx, 0.01));
      expect(tester.getCenter(icon).dy, closeTo(rect.center.dy, 0.01));
    }
    final gap = GameSpacing.gap * HomeLayout(const Size(390, 844)).scale;
    expect(rects[1].left - rects[0].right, closeTo(gap, 0.01));
    expect(rects[2].left - rects[1].right, closeTo(gap, 0.01));
    final utilities = find.descendant(
      of: find.byType(HomeUtilities),
      matching: find.byType(TextButton),
    );
    expect(utilities, findsNWidgets(3));
    for (final frame in utilities.evaluate()) {
      final finder = find.byWidget(frame.widget);
      final icon = find.descendant(
        of: finder,
        matching: find.byType(PixelIcon),
      );
      expect(tester.getCenter(icon), tester.getCenter(finder));
      expect(tester.getSize(finder).shortestSide, greaterThanOrEqualTo(48));
    }
    expect(tester.takeException(), isNull);
  });

  for (final portrait in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets('rotation preserves component sizes for $portrait', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const ids = [
        'home-profile',
        'home-resources',
        'home-quests',
        'home-utilities',
        'home-dialogue',
        'home-actions',
        'home-navigation',
        'character-placeholder',
      ];
      final before = <String, Rect>{};
      for (final viewport in [
        portrait,
        Size(portrait.height, portrait.width),
      ]) {
        tester.view.physicalSize = viewport;
        await tester.pumpWidget(
          MaterialApp(theme: appTheme, home: const HomeScreen()),
        );
        await tester.pumpAndSettle();
        final bounds = Offset.zero & viewport;
        for (final id in ids) {
          final rect = tester.getRect(find.byKey(ValueKey(id)));
          expect(rect.left, greaterThanOrEqualTo(-0.01), reason: id);
          expect(rect.top, greaterThanOrEqualTo(-0.01), reason: id);
          expect(
            rect.right,
            lessThanOrEqualTo(bounds.right + 0.01),
            reason: id,
          );
          expect(
            rect.bottom,
            lessThanOrEqualTo(bounds.bottom + 0.01),
            reason: id,
          );
          if (before.containsKey(id)) {
            expect(rect.width, closeTo(before[id]!.width, 0.01), reason: id);
            expect(rect.height, closeTo(before[id]!.height, 0.01), reason: id);
          } else {
            before[id] = rect;
          }
        }
        final quests = tester.getRect(
          find.byKey(const ValueKey('home-quests')),
        );
        final dialogue = tester.getRect(
          find.byKey(const ValueKey('home-dialogue')),
        );
        final character = tester.getRect(
          find.byKey(const ValueKey('character-placeholder')),
        );
        final navigation = tester.getRect(
          find.byKey(const ValueKey('home-navigation')),
        );
        expect(quests.overlaps(dialogue), isFalse);
        expect(character.overlaps(dialogue), isFalse);
        expect(character.overlaps(quests), isFalse);
        expect(navigation.center.dx, closeTo(viewport.width / 2, 0.01));
        expect(dialogue.center.dx, closeTo(viewport.width / 2, 0.01));
        expect(character.center.dx, closeTo(viewport.width / 2, 0.01));
        expect(
          tester.getCenter(find.byTooltip('Cốt truyện')).dy,
          closeTo(tester.getCenter(find.byTooltip('Trang chủ')).dy, 0.1),
        );
        expect(find.byType(SingleChildScrollView), findsNothing);
        expect(tester.takeException(), isNull);
      }
    });
  }

  testWidgets('extra width moves anchors without stretching panels', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final before = <String, Rect>{};
    const groups = [
      'home-profile',
      'home-quests',
      'home-resources',
      'home-utilities',
      'home-dialogue',
      'home-actions',
      'home-navigation',
    ];
    for (final width in [390.0, 1440.0]) {
      tester.view.physicalSize = Size(width, 844);
      await tester.pumpWidget(
        MaterialApp(theme: appTheme, home: const HomeScreen()),
      );
      await tester.pumpAndSettle();
      for (final id in groups) {
        final rect = tester.getRect(find.byKey(ValueKey(id)));
        if (before.containsKey(id)) {
          expect(rect.width, closeTo(before[id]!.width, 0.0001), reason: id);
          expect(rect.height, closeTo(before[id]!.height, 0.0001), reason: id);
          if (id == 'home-profile' || id == 'home-quests') {
            expect(rect.left, before[id]!.left);
          } else if (id == 'home-resources' || id == 'home-utilities') {
            expect(width - rect.right, closeTo(390 - before[id]!.right, 0.01));
          } else {
            expect(rect.center.dx, width / 2);
            expect(rect.bottom, before[id]!.bottom);
          }
        } else {
          before[id] = rect;
        }
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('safe insets move anchors without shrinking UI on rotation', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Rect? portrait;
    for (final size in [const Size(390, 844), const Size(844, 390)]) {
      tester.view.physicalSize = size;
      final padding = size.width < size.height
          ? const EdgeInsets.only(top: 44, bottom: 24)
          : const EdgeInsets.fromLTRB(44, 0, 44, 24);
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(padding: padding),
            child: child!,
          ),
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();
      final profile = tester.getRect(
        find.byKey(const ValueKey('home-profile')),
      );
      final nav = tester.getRect(find.byKey(const ValueKey('home-navigation')));
      final layout = HomeLayout(size, deviceShortSide: size.shortestSide);
      final edge = GameSpacing.edge * layout.scale;
      expect(profile.left, closeTo(padding.left + edge, 0.01));
      expect(profile.top, closeTo(padding.top + edge, 0.01));
      expect(nav.bottom, lessThanOrEqualTo(size.height - padding.bottom));
      if (portrait != null) expect(profile.size, portrait.size);
      portrait = profile;
      expect(tester.takeException(), isNull);
    }
  });
}

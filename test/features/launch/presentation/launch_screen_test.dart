import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/pixel_rpg_app.dart';
import 'package:pixel_rpg/features/home/presentation/home_screen.dart';
import 'package:pixel_rpg/features/launch/presentation/launch_screen.dart';
import 'package:pixel_rpg/features/launch/presentation/neon_progress_bar.dart';

void main() {
  testWidgets('fills over three seconds then replaces launch with home', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PixelRpgApp()));
    await tester.pump();
    expect(
      tester.widget<NeonProgressBar>(find.byType(NeonProgressBar)).progress,
      0,
    );

    await tester.pump(const Duration(milliseconds: 1500));
    expect(
      tester.widget<NeonProgressBar>(find.byType(NeonProgressBar)).progress,
      closeTo(0.5, 0.01),
    );
    expect(find.byType(HomeScreen), findsNothing);

    await tester.pump(const Duration(milliseconds: 1499));
    expect(find.text('Loading...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(LaunchScreen), findsNothing);
    expect(find.text('Pixel RPG'), findsOneWidget);
  });

  testWidgets('leaving loading early cancels completion', (tester) async {
    var completions = 0;
    await tester.pumpWidget(
      MaterialApp(home: LaunchScreen(onComplete: () => completions++)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 4));
    expect(completions, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('small screens and enlarged text do not overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: LaunchScreen(onComplete: () {}),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1500));
    expect(tester.takeException(), isNull);
    expect(find.text('Loading...'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

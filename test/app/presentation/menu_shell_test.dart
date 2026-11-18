import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/presentation/menu_shell.dart';
import 'package:pixel_rpg/app/theme/app_theme.dart';

void main() {
  testWidgets('compact menu header stays above the scrolling content', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    String? destination;
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: MenuShell(
          title: 'Cửa hàng',
          selected: 'shop',
          onNavigate: (value) => destination = value,
          child: const SizedBox(
            height: 1000,
            child: Align(alignment: Alignment.topLeft, child: Text('Nội dung')),
          ),
        ),
      ),
    );

    expect(find.byTooltip('Quay lại'), findsOneWidget);
    final back = find.widgetWithIcon(IconButton, Icons.arrow_back);
    final title = find.text('Cửa hàng');
    final content = find.byKey(const ValueKey('menu-content'));
    final backRect = tester.getRect(back);
    final titleRect = tester.getRect(title);
    expect(backRect.width, greaterThanOrEqualTo(48));
    expect(backRect.height, greaterThanOrEqualTo(48));
    expect(
      tester.getTopLeft(content).dy - backRect.bottom,
      lessThanOrEqualTo(4),
    );

    await tester.drag(content, const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(tester.getRect(back), backRect);
    expect(tester.getRect(title), titleRect);
    expect(find.text('Nội dung').hitTestable(), findsNothing);

    await tester.tapAt(backRect.topLeft + const Offset(2, 2));
    expect(destination, 'home');
  });
}

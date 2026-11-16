import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/app/pixel_rpg_app.dart';

void main() {
  testWidgets('boots the launch route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PixelRpgApp()));
    await tester.pumpAndSettle();

    expect(find.text('Pixel RPG'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

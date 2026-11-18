import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pixel_rpg/features/profile/application/profile_card_controller.dart';
import 'package:pixel_rpg/features/profile/domain/profile_card.dart';

import '../../../support/profile_card_test_scope.dart';

void main() {
  test('creates and stores the friend code once across sessions', () async {
    final store = TestProfileCardStore(null);
    Future<ProfileCard> openProfile() async {
      final container = ProviderContainer(
        overrides: [profileCardStoreProvider.overrideWithValue(store)],
      );
      try {
        return await container.read(profileCardProvider.future);
      } finally {
        container.dispose();
      }
    }

    final first = await openProfile();
    expect(first.friendCode, matches(r'^PRG(-[A-Z2-9]{4}){3}$'));
    expect((await openProfile()).friendCode, first.friendCode);
  });
}

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_rpg/features/profile/domain/profile_card.dart';
import 'package:pixel_rpg/features/profile/domain/profile_card_store.dart';
import 'package:pixel_rpg/features/profile/infrastructure/preferences_profile_card_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/profile_card_test_scope.dart';

void main() {
  test('round trips the versioned card with optional fields', () async {
    final preferences = _Preferences();
    final store = PreferencesProfileCardStore(preferences);
    expect(await store.load(), isA<ProfileCardSuccess<ProfileCard?>>());
    final edited = ProfileCard(
      friendCode: testFriendCode,
      name: 'An',
      title: 'Dẫn đường',
      bio: 'Hẹn gặp ở rừng.',
      background: ProfileBackground.forest,
      avatar: ProfileAvatar.ranger,
      companion: null,
      badges: {ProfileBadge.explorer},
      showStats: false,
    );
    expect(await store.save(edited), isA<ProfileCardSuccess<void>>());

    final result = await PreferencesProfileCardStore(preferences).load();
    final restored = (result as ProfileCardSuccess<ProfileCard?>).value!;
    expect(restored.friendCode, edited.friendCode);
    expect(restored.name, edited.name);
    expect(restored.title, edited.title);
    expect(restored.bio, edited.bio);
    expect(restored.background, edited.background);
    expect(restored.avatar, edited.avatar);
    expect(restored.companion, isNull);
    expect(restored.badges, edited.badges);
    expect(restored.showStats, isFalse);
  });

  test(
    'classifies an unsupported record and a platform write failure',
    () async {
      final preferences = _Preferences()..raw = '{"version":2}';
      final store = PreferencesProfileCardStore(preferences);
      final result = await store.load() as ProfileCardFailure<ProfileCard?>;
      expect(result.kind, ProfileCardFailureKind.unreadable);
      preferences.failWrite = true;
      final write =
          await store.save(ProfileCard(friendCode: testFriendCode))
              as ProfileCardFailure<void>;
      expect(write.kind, ProfileCardFailureKind.unavailable);
      expect(preferences.raw, '{"version":2}');
    },
  );
}

class _Preferences implements SharedPreferencesAsync {
  final _state = _PreferenceState();
  String? get raw => _state.raw;
  set raw(String? value) => _state.raw = value;
  set failWrite(bool value) => _state.failWrite = value;

  @override
  Future<String?> getString(String key) async => raw;

  @override
  Future<void> setString(String key, String value) async {
    if (_state.failWrite) throw PlatformException(code: 'test');
    raw = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PreferenceState {
  String? raw;
  bool failWrite = false;
}

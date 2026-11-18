import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/profile_card.dart';
import '../domain/profile_card_store.dart';

class PreferencesProfileCardStore implements ProfileCardStore {
  PreferencesProfileCardStore(this._preferences);

  final SharedPreferencesAsync _preferences;
  static const _key = 'profile.card';

  @override
  Future<ProfileCardResult<ProfileCard?>> load() async {
    try {
      final raw = await _preferences.getString(_key);
      return ProfileCardSuccess(raw == null ? null : _decode(raw));
    } on FormatException catch (error, stack) {
      return ProfileCardFailure(
        ProfileCardFailureKind.unreadable,
        error,
        stack,
      );
    } on TypeError catch (error, stack) {
      return ProfileCardFailure(
        ProfileCardFailureKind.unreadable,
        error,
        stack,
      );
    } on Exception catch (error, stack) {
      return ProfileCardFailure(
        ProfileCardFailureKind.unavailable,
        error,
        stack,
      );
    }
  }

  @override
  Future<ProfileCardResult<void>> save(ProfileCard card) async {
    try {
      await _preferences.setString(
        _key,
        jsonEncode({
          'version': 1,
          'friendCode': card.friendCode,
          'name': card.name,
          'title': card.title,
          'bio': card.bio,
          'background': card.background.name,
          'avatar': card.avatar.name,
          'companion': card.companion,
          'badges': [for (final badge in card.badges) badge.name],
          'showStats': card.showStats,
        }),
      );
      return const ProfileCardSuccess(null);
    } on Exception catch (error, stack) {
      return ProfileCardFailure(
        ProfileCardFailureKind.unavailable,
        error,
        stack,
      );
    }
  }

  ProfileCard _decode(String raw) {
    final Object? json = jsonDecode(raw);
    if (json case {
      'version': 1,
      'friendCode': final String code,
      'name': final String name,
      'title': final String title,
      'bio': final String bio,
      'background': final String background,
      'avatar': final String avatar,
      'companion': final String? companion,
      'badges': final List<Object?> badges,
      'showStats': final bool showStats,
    }) {
      final backgroundChoice = _decodeOption(
        ProfileBackground.values,
        background,
      );
      final avatarChoice = _decodeOption(ProfileAvatar.values, avatar);
      final badgeChoices = badges
          .map((badge) => _decodeOption(ProfileBadge.values, badge))
          .toSet();
      return ProfileCard(
        friendCode: code,
        name: name,
        title: title,
        bio: bio,
        background: backgroundChoice,
        avatar: avatarChoice,
        companion: companion,
        badges: badgeChoices,
        showStats: showStats,
      );
    }
    throw const FormatException('Invalid or unsupported profile card');
  }

  T _decodeOption<T extends Enum>(List<T> values, Object? id) {
    for (final value in values) {
      if (value.name == id) return value;
    }
    throw const FormatException('Unknown profile card option');
  }
}

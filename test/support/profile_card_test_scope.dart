import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixel_rpg/features/profile/application/profile_card_controller.dart';
import 'package:pixel_rpg/features/profile/domain/profile_card.dart';
import 'package:pixel_rpg/features/profile/domain/profile_card_store.dart';

const testFriendCode = 'PRG-F8J3-N5PW-T3Q7';

class TestProfileCardStore implements ProfileCardStore {
  TestProfileCardStore(this.card);

  ProfileCard? card;
  bool failSave = false;

  @override
  Future<ProfileCardResult<ProfileCard?>> load() async =>
      ProfileCardSuccess(card);

  @override
  Future<ProfileCardResult<void>> save(ProfileCard card) async {
    if (failSave) {
      return ProfileCardFailure(
        ProfileCardFailureKind.unavailable,
        StateError('Test storage unavailable'),
        StackTrace.current,
      );
    }
    this.card = card;
    return const ProfileCardSuccess(null);
  }
}

Widget withProfileCard(Widget child, {TestProfileCardStore? store}) =>
    ProviderScope(
      overrides: [
        profileCardStoreProvider.overrideWithValue(
          store ??
              TestProfileCardStore(ProfileCard(friendCode: testFriendCode)),
        ),
      ],
      child: child,
    );

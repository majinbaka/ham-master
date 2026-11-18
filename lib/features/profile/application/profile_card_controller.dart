import 'dart:math';

import 'package:riverpod/riverpod.dart';

import '../domain/profile_card.dart';
import '../domain/profile_card_store.dart';

final profileCardStoreProvider = Provider<ProfileCardStore>(
  (ref) => throw StateError('ProfileCardStore must be provided by the app'),
);

final profileCardProvider =
    AsyncNotifierProvider<ProfileCardController, ProfileCard>(
      ProfileCardController.new,
    );

class ProfileCardController extends AsyncNotifier<ProfileCard> {
  @override
  Future<ProfileCard> build() async {
    final store = ref.watch(profileCardStoreProvider);
    final result = await store.load();
    switch (result) {
      case ProfileCardSuccess(value: final card?):
        return card;
      case ProfileCardSuccess():
        final card = ProfileCard(friendCode: _createFriendCode());
        final saved = await store.save(card);
        switch (saved) {
          case ProfileCardSuccess():
            return card;
          case ProfileCardFailure():
            Error.throwWithStackTrace(saved, saved.stackTrace);
        }
      case ProfileCardFailure():
        Error.throwWithStackTrace(result, result.stackTrace);
    }
  }

  Future<bool> saveEdits(ProfileCard card) async {
    final result = await ref.read(profileCardStoreProvider).save(card);
    if (result is ProfileCardFailure<void>) return false;
    state = AsyncData(card);
    return true;
  }

  String _createFriendCode() {
    const alphabet = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
    final random = Random.secure();
    final groups = List.generate(
      3,
      (_) => List.generate(
        4,
        (_) => alphabet[random.nextInt(alphabet.length)],
      ).join(),
    );
    return 'PRG-${groups.join('-')}';
  }
}

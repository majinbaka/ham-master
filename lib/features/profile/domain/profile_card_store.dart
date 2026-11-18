import 'profile_card.dart';

sealed class ProfileCardResult<T> {
  const ProfileCardResult();
}

class ProfileCardSuccess<T> extends ProfileCardResult<T> {
  const ProfileCardSuccess(this.value);

  final T value;
}

enum ProfileCardFailureKind { unavailable, unreadable }

class ProfileCardFailure<T> extends ProfileCardResult<T> implements Exception {
  const ProfileCardFailure(this.kind, this.cause, this.stackTrace);

  final ProfileCardFailureKind kind;
  final Object cause;
  final StackTrace stackTrace;
}

abstract interface class ProfileCardStore {
  /// A successful null read means the installation has no card yet.
  Future<ProfileCardResult<ProfileCard?>> load();

  Future<ProfileCardResult<void>> save(ProfileCard card);
}

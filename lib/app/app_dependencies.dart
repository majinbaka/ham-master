import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/profile/application/profile_card_controller.dart';
import '../features/profile/infrastructure/preferences_profile_card_store.dart';

class AppDependencies extends StatelessWidget {
  const AppDependencies({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      profileCardStoreProvider.overrideWith(
        (ref) => PreferencesProfileCardStore(SharedPreferencesAsync()),
      ),
    ],
    child: child,
  );
}

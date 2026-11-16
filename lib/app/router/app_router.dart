import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/launch/presentation/launch_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'launch',
        builder: (context, state) => const LaunchScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/launch/presentation/launch_screen.dart';
import '../../features/quests/presentation/quest_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'launch',
        builder: (context, state) =>
            LaunchScreen(onComplete: () => context.goNamed('home')),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) =>
            HomeScreen(onOpenQuests: () => context.goNamed('quests')),
        routes: [
          GoRoute(
            path: 'quests',
            name: 'quests',
            builder: (context, state) =>
                QuestScreen(onBack: () => context.pop()),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

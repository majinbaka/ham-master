import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/battle/presentation/battle_screen.dart';
import '../../features/beasts/presentation/beast_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/launch/presentation/launch_screen.dart';
import '../../features/quests/presentation/quest_screen.dart';
import '../../features/story/presentation/story_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

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
        builder: (context, state) => HomeScreen(
          onOpenQuests: () => context.goNamed('quests'),
          onOpenSideQuests: () => context.goNamed(
            'quests',
            queryParameters: {'tab': QuestCategory.side.name},
          ),
          onOpenDailyQuests: () => context.goNamed(
            'quests',
            queryParameters: {'tab': QuestCategory.daily.name},
          ),
          onOpenBattle: () => context.pushNamed('battle'),
          onNavigate: context.goNamed,
        ),
        routes: [
          GoRoute(
            path: 'story',
            name: 'story',
            builder: (context, state) => StoryScreen(
              onNavigate: context.goNamed,
              onStart: () => context.goNamed('story-episode'),
            ),
            routes: [
              GoRoute(
                path: 'episode',
                name: 'story-episode',
                builder: (context, state) => StoryEpisodeScreen(
                  onBack: () => context.goNamed('story'),
                  onNavigate: context.goNamed,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'shop',
            name: 'shop',
            builder: (context, state) =>
                ShopScreen(onNavigate: context.goNamed),
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) =>
                ProfileScreen(onNavigate: context.goNamed),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) =>
                SettingsScreen(onNavigate: context.goNamed),
          ),
          GoRoute(
            path: 'beasts',
            name: 'beasts',
            builder: (context, state) => BeastScreen(
              onNavigate: context.goNamed,
              onBattle: () => context.pushNamed('battle'),
            ),
          ),
          GoRoute(
            path: 'battle',
            name: 'battle',
            builder: (context, state) => BattleScreen(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed('home');
                }
              },
            ),
          ),
          GoRoute(
            path: 'quests',
            name: 'quests',
            builder: (context, state) {
              final category =
                  QuestCategory.values
                      .asNameMap()[state.uri.queryParameters['tab']] ??
                  QuestCategory.main;
              return QuestScreen(
                key: ValueKey(category),
                initialCategory: category,
                onBattle: () => context.pushNamed('battle'),
                onBack: () => context.goNamed('home'),
                onNavigate: context.goNamed,
              );
            },
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

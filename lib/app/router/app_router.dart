import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/battle/presentation/battle_screen.dart';
import '../../features/beasts/presentation/beast_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/launch/presentation/launch_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';

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
          onOpenBattle: () => context.pushNamed('battle'),
          onNavigate: context.goNamed,
        ),
        routes: [
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
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

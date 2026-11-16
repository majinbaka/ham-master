import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PixelRpgApp extends ConsumerWidget {
  const PixelRpgApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Pixel RPG',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}

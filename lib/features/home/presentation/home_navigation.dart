import 'package:flutter/material.dart';

import '../../../app/presentation/pixel_navigation.dart';

/// Home uses the same logical-pixel navigation controls as menu screens.
class HomeNavigation extends StatelessWidget {
  const HomeNavigation({this.onNavigate, super.key});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) =>
      PixelNavigation(selected: 'home', onNavigate: onNavigate);
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'home_footer.dart';
import 'home_hud.dart';
import 'home_layout.dart';
import 'home_navigation.dart';
import 'home_overview.dart';

/// Fixed-proportion game HUD over a scene that expands with the viewport.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = HomeLayout(
            constraints.biggest,
            deviceShortSide: MediaQuery.sizeOf(context).shortestSide,
          );
          return Stack(
            children: [
              _place(
                'home-profile',
                layout.profile,
                layout.scale,
                const HomeProfile(),
              ),
              _place(
                'home-resources',
                layout.resources,
                layout.scale,
                const HomeResources(),
              ),
              _place(
                'home-quests',
                layout.quests,
                layout.scale,
                const HomeQuests(),
              ),
              _place(
                'home-utilities',
                layout.utilities,
                layout.scale,
                const HomeUtilities(),
              ),
              _place(
                'home-minimap',
                layout.minimap,
                layout.scale,
                const HomeMinimap(),
              ),
              Positioned.fromRect(
                rect: layout.character,
                child: Semantics(
                  label: 'Nhân vật tạm: khối màu vàng',
                  image: true,
                  child: const ColoredBox(
                    key: ValueKey('character-placeholder'),
                    color: PixelUiColors.gold,
                  ),
                ),
              ),
              _place(
                'home-dialogue',
                layout.dialogue,
                layout.scale,
                const HomeDialogue(),
              ),
              _place(
                'home-actions',
                layout.actions,
                layout.scale,
                const HomeActions(),
              ),
              _place(
                'home-navigation',
                layout.navigation,
                layout.scale,
                const HomeNavigation(),
              ),
              // Keep the real control's hit target at least 48 logical pixels,
              // independently of the fixed-size artwork underneath it.
              Positioned(
                right: 0,
                top: math.max(0, layout.utilities.center.dy - 24),
                width: 48,
                height: 48,
                child: IconButton(
                  tooltip: 'Thông tin màn hình',
                  onPressed: () => _showInformation(context),
                  icon: const SizedBox.shrink(),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  Widget _place(String key, Rect rect, double scale, Widget child) =>
      Positioned.fromRect(
        rect: rect,
        child: SizedBox(
          key: ValueKey(key),
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: rect.width / scale,
              height: rect.height / scale,
              child: child,
            ),
          ),
        ),
      );

  void _showInformation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: PixelUiColors.surface,
        title: const Text('Chào mừng đến với Pixel RPG'),
        content: const SingleChildScrollView(
          child: Text(
            'Đây là bản dựng giao diện màn hình chính. Nhân vật được thay tạm bằng khối vàng trên nền đen.\n\n'
            'Nhiệm vụ, bản đồ, tài nguyên và các chức năng gameplay chưa được mở.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }
}

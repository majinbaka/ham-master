import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/presentation/player_hud.dart';
import '../../../app/presentation/scaled_artwork.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import 'home_footer.dart';
import 'home_layout.dart';
import 'home_navigation.dart';
import 'home_overview.dart';
import 'home_reading_view.dart';

/// Fixed-proportion game HUD over a scene that expands with the viewport.
class HomeScreen extends StatelessWidget {
  const HomeScreen({this.onOpenQuests, this.onNavigate, super.key});

  final VoidCallback? onOpenQuests;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(17) > 17 * 1.15
      ? HomeReadingView(
          onOpenQuests: onOpenQuests,
          onNavigate: onNavigate,
          onInformation: () => _showInformation(context),
        )
      : Scaffold(
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
                      const PlayerHud(),
                    ),
                    _place(
                      'home-resources',
                      layout.resources,
                      layout.scale,
                      const ResourceHud(),
                    ),
                    _placeContent(
                      'home-quests',
                      layout.quests,
                      HomeQuests(onOpen: onOpenQuests),
                    ),
                    _place(
                      'home-utilities',
                      layout.utilities,
                      layout.scale,
                      const HomeUtilities(),
                    ),
                    _placeContent(
                      'home-minimap',
                      layout.minimap,
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
                    _placeContent(
                      'home-dialogue',
                      layout.dialogue,
                      const HomeDialogue(),
                    ),
                    _place(
                      'home-actions',
                      layout.actions,
                      layout.scale,
                      const HomeActions(),
                    ),
                    Positioned.fromRect(
                      rect: layout.navigation,
                      child: SizedBox(
                        key: const ValueKey('home-navigation'),
                        child: HomeNavigation(onNavigate: onNavigate),
                      ),
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
                        // Artwork is rendered below; this is only its touch target.
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(),
                        ),
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
          child: ScaledArtwork(
            scale: scale,
            size: Size(rect.width / scale, rect.height / scale),
            child: child,
          ),
        ),
      );

  Widget _placeContent(String key, Rect rect, Widget child) =>
      Positioned.fromRect(
        rect: rect,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(key: ValueKey(key), width: rect.width, child: child),
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
            'Thanh dưới mở Cốt truyện, Nhiệm vụ, Cửa hàng, Hồ sơ và Cài đặt với dữ liệu mẫu, không lưu thay đổi. '
            'Bản đồ, tài nguyên và các chức năng gameplay chưa được mở.',
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

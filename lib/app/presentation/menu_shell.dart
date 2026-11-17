import 'package:flutter/material.dart';

import '../theme/pixel_ui_colors.dart';
import '../theme/game_typography.dart';
import 'game_chrome_layout.dart';
import 'village_backdrop.dart';
import 'game_spacing.dart';
import 'pixel/pixel_frame.dart';
import 'pixel_navigation.dart';
import 'player_hud.dart';
import 'scaled_artwork.dart';

/// Menus share Home's HUD, density and bottom anchors; only the middle scrolls.
class MenuShell extends StatelessWidget {
  const MenuShell({
    required this.title,
    required this.selected,
    required this.onNavigate,
    required this.child,
    this.onBack,
    this.backLabel = 'Quay lại',
    super.key,
  });

  final String title;
  final String selected;
  final ValueChanged<String> onNavigate;
  final Widget child;
  final VoidCallback? onBack;
  final String backLabel;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = GameChromeLayout(
            constraints.biggest,
            deviceShortSide: MediaQuery.sizeOf(context).shortestSide,
          );
          final gap = GameSpacing.gap * layout.scale;
          return Stack(
            children: [
              const Positioned.fill(child: VillageBackdrop(dimmed: true)),
              Positioned.fromRect(
                rect: layout.profile,
                child: ScaledArtwork(
                  size: const Size(440, 120),
                  scale: layout.scale,
                  child: const PlayerHud(),
                ),
              ),
              Positioned.fromRect(
                rect: layout.resources,
                child: ScaledArtwork(
                  size: const Size(420, 120),
                  scale: layout.scale,
                  child: const ResourceHud(),
                ),
              ),
              Positioned(
                left: gap,
                right: gap,
                top: layout.profile.bottom + gap,
                bottom: constraints.maxHeight - layout.navigation.top + gap,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: backLabel,
                              onPressed: onBack ?? () => onNavigate('home'),
                              icon: const Icon(Icons.arrow_back, size: 30),
                            ),
                            Expanded(
                              child: PixelFrame(
                                skin: PixelFrameSkin.gold,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GameTypography.title.copyWith(
                                    color: PixelUiColors.gold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: PixelFrame(
                            skin: PixelFrameSkin.cool,
                            padding: const EdgeInsets.all(8),
                            child: SingleChildScrollView(
                              key: const ValueKey('menu-content'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 8,
                                children: [
                                  Text(
                                    'BẢN XEM TRƯỚC · Dữ liệu mẫu · Không lưu thay đổi',
                                    textAlign: TextAlign.center,
                                    style: GameTypography.caption.copyWith(
                                      color: PixelUiColors.cool,
                                    ),
                                  ),
                                  child,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: layout.navigation,
                child: PixelNavigation(
                  selected: selected,
                  onNavigate: onNavigate,
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

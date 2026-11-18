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

/// Menus share Home's character bar and bottom navigation; only content scrolls.
class MenuShell extends StatelessWidget {
  const MenuShell({
    required this.title,
    required this.selected,
    required this.onNavigate,
    required this.child,
    this.onBack,
    this.showBack = true,
    this.backLabel = 'Quay lại',
    this.notice = 'Dữ liệu mẫu · Không lưu thay đổi',
    super.key,
  });

  final String title;
  final String selected;
  final ValueChanged<String> onNavigate;
  final Widget child;
  final VoidCallback? onBack;
  final bool showBack;
  final String backLabel;
  final String? notice;

  @override
  Widget build(BuildContext context) => Scaffold(
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
              const Positioned.fill(child: VillageBackdrop(softened: true)),
              Positioned.fromRect(
                rect: layout.profile,
                child: ScaledArtwork(
                  size: GameChromeLayout.profileSize,
                  scale: layout.scale,
                  child: const PlayerHud(),
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
                    child: PixelFrame(
                      skin: PixelFrameSkin.cream,
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: showBack ? 4 : 8,
                              right: 8,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 48),
                              child: Row(
                                spacing: 4,
                                children: [
                                  if (showBack)
                                    IconButton(
                                      tooltip: backLabel,
                                      onPressed:
                                          onBack ?? () => onNavigate('home'),
                                      style: IconButton.styleFrom(
                                        minimumSize: const Size.square(36),
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.padded,
                                      ),
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        size: 24,
                                      ),
                                    ),
                                  Expanded(
                                    child: Semantics(
                                      header: true,
                                      child: Text(
                                        title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GameTypography.menuTitle
                                            .copyWith(
                                              color: PixelUiColors.outline,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: SingleChildScrollView(
                                key: const ValueKey('menu-content'),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  spacing: 8,
                                  children: [
                                    if (notice != null)
                                      Text(
                                        notice!,
                                        textAlign: TextAlign.center,
                                        style: GameTypography.caption.copyWith(
                                          color: PixelUiColors.mutedInk,
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

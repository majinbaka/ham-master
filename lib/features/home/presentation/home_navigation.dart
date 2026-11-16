import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'home_spacing.dart';
import 'pixel_frame.dart';
import 'pixel_frame_skin.dart' show PixelFrameArtwork;
import 'pixel_icon.dart';

/// Six fixed slots in one row, independent of the viewport's aspect ratio.
class HomeNavigation extends StatelessWidget {
  const HomeNavigation({super.key});

  static const _items = [
    (PixelIconKind.home, 'Trang chủ'),
    (PixelIconKind.compass, 'Khám phá'),
    (PixelIconKind.beasts, 'Quái thú'),
    (PixelIconKind.battle, 'Chiến đấu'),
    (PixelIconKind.backpack, 'Túi đồ'),
    (PixelIconKind.story, 'Cốt truyện'),
  ];

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: const EdgeInsets.all(HomeSpacing.small),
    child: Row(
      children: [
        for (var i = 0; i < _items.length; i++)
          Expanded(
            child: Semantics(
              selected: i == 0,
              enabled: i == 0,
              label: '${_items[i].$2}${i == 0 ? '' : ', chưa mở'}',
              excludeSemantics: true,
              child: _NavigationSlot(
                selected: i == 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PixelIcon(_items[i].$1, size: 50),
                      const SizedBox(height: HomeSpacing.small),
                      SizedBox(
                        height: 30,
                        child: PixelLabel(
                          _items[i].$2,
                          fontSize: 25,
                          color: i == 0
                              ? PixelUiColors.outline
                              : PixelUiColors.paper,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: i == 0
                            ? null
                            : const PixelLabel(
                                'Chưa mở',
                                fontSize: 16,
                                color: PixelUiColors.cool,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

/// Only the selected entry gets a plate, matching the shared navigation tray.
class _NavigationSlot extends StatelessWidget {
  const _NavigationSlot({required this.selected, required this.child});

  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      if (selected)
        const Positioned.fill(
          child: PixelFrameArtwork(skin: PixelFrameSkin.selected),
        ),
      Padding(padding: const EdgeInsets.all(HomeSpacing.small), child: child),
    ],
  );
}

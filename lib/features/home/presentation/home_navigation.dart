import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'pixel_frame.dart';

/// Six fixed slots in one row, independent of the viewport's aspect ratio.
class HomeNavigation extends StatelessWidget {
  const HomeNavigation({super.key});

  static const _items = [
    (Icons.home_outlined, 'Trang chủ'),
    (Icons.explore_outlined, 'Khám phá'),
    (Icons.pets_outlined, 'Quái thú'),
    (Icons.shield_outlined, 'Chiến đấu'),
    (Icons.backpack_outlined, 'Túi đồ'),
    (Icons.menu_book_outlined, 'Cốt truyện'),
  ];

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: const EdgeInsets.all(12),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _items[i].$1,
                      size: 58,
                      color: i == 0
                          ? PixelUiColors.outline
                          : PixelUiColors.cool,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 32,
                      child: PixelLabel(
                        _items[i].$2,
                        fontSize: 25,
                        color: i == 0
                            ? PixelUiColors.outline
                            : PixelUiColors.paper,
                      ),
                    ),
                    SizedBox(
                      height: 22,
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
  Widget build(BuildContext context) => selected
      ? PixelFrame(
          skin: PixelFrameSkin.selected,
          padding: const EdgeInsets.all(6),
          child: child,
        )
      : Padding(padding: const EdgeInsets.all(10), child: child);
}

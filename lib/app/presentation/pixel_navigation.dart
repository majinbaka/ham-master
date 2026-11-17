import 'package:flutter/material.dart';

import 'menu_button.dart';
import 'pixel/pixel_frame.dart';
import 'pixel/pixel_icon.dart';

/// Route metadata and navigation visuals shared by home and every menu.
const menuDestinations = [
  ('home', 'Trang chủ', PixelIconKind.home),
  ('story', 'Cốt truyện', PixelIconKind.story),
  ('quests', 'Nhiệm vụ', PixelIconKind.quest),
  ('shop', 'Cửa hàng', PixelIconKind.coin),
  ('profile', 'Hồ sơ', PixelIconKind.beasts),
  ('settings', 'Cài đặt', PixelIconKind.tasks),
];

class PixelNavigation extends StatelessWidget {
  const PixelNavigation({
    required this.selected,
    required this.onNavigate,
    super.key,
  });
  final String selected;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: EdgeInsets.zero,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 2,
      children: [
        for (final (route, label, icon) in menuDestinations)
          Expanded(
            child: MenuButton(
              label: label,
              icon: icon,
              selected: route == selected,
              onPressed: onNavigate == null ? null : () => onNavigate!(route),
            ),
          ),
      ],
    ),
  );
}

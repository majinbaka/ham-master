import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

/// Browsable sample catalogue; no payments, purchases or resource mutations.
class ShopScreen extends StatefulWidget {
  const ShopScreen({required this.onNavigate, super.key});
  final ValueChanged<String> onNavigate;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  var _category = 0;
  static const _tabs = ['Đề cử', 'Vật phẩm', 'Trang bị', 'Đá nâng cấp', 'Khác'];
  static const _items = [
    ('Thuốc hồi phục', PixelIconKind.energy, '120 ngọc', 1),
    ('Vé hành trình', PixelIconKind.bookmark, '90 ngọc', 1),
    ('Kiếm tập luyện', PixelIconKind.battle, '300 vàng', 2),
    ('Đá ánh sáng', PixelIconKind.gem, '160 ngọc', 3),
    ('Túi tiếp tế', PixelIconKind.backpack, '500 vàng', 4),
    ('Sổ khám phá', PixelIconKind.story, '200 vàng', 4),
  ];

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Cửa hàng',
    selected: 'shop',
    onNavigate: widget.onNavigate,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        const MenuPanel(
          title: 'Tiệm nhỏ bên đường',
          light: true,
          child: Row(
            spacing: 8,
            children: [
              PixelIcon(PixelIconKind.coin, size: 48),
              Expanded(child: Text('Chọn chút hành trang cho chuyến đi mới.')),
            ],
          ),
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final (index, tab) in _tabs.indexed)
              MenuButton(
                label: tab,
                selected: index == _category,
                onPressed: () => setState(() => _category = index),
              ),
          ],
        ),
        if (_category == 0)
          MenuPanel(
            title: 'Gói khởi hành',
            child: Row(
              children: [
                const PixelIcon(PixelIconKind.backpack, size: 48),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      const Text('300 ngọc · 30.000 vàng · 10 vật phẩm'),
                      MenuButton(
                        label: 'Xem gói mẫu',
                        selected: true,
                        onPressed: () => showSampleDetail(
                          context,
                          'Gói khởi hành',
                          'Gói minh họa gồm tài nguyên và vật phẩm khởi hành.',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        MenuPanel(
          title: 'Vật phẩm · ${_tabs[_category]}',
          child: MenuGrid(
            children: [
              for (final (name, icon, price, category) in _items)
                if (_category == 0 || category == _category)
                  MenuButton(
                    label: '$name\n$price\nXem chi tiết',
                    icon: icon,
                    showLabel: true,
                    onPressed: () => showSampleDetail(
                      context,
                      name,
                      'Giá minh họa: $price. Vật phẩm chuẩn bị cho hành trình.',
                    ),
                  ),
            ],
          ),
        ),
        MenuPanel(
          title: 'Gói đặc biệt',
          child: MenuGrid(
            children: [
              for (final name in [
                'Gói sưu tầm',
                'Gói huấn luyện',
                'Gói phiêu lưu',
              ])
                MenuButton(
                  label: name,
                  icon: PixelIconKind.backpack,
                  showLabel: true,
                  onPressed: () => showSampleDetail(
                    context,
                    name,
                    'Bản xem trước gói vật phẩm. Chưa có giá bán hoặc thanh toán.',
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

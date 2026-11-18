import 'package:flutter/material.dart';

import '../../../app/theme/game_typography.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/traveler_portrait.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.onNavigate, super.key});
  final ValueChanged<String> onNavigate;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _tab = 0;

  static const _collection = [
    (
      'Bạn đồng hành',
      PixelIconKind.beasts,
      'Ghi chép về người bạn đang đợi ở trại khởi hành.',
    ),
    (
      'Dấu chân nhỏ',
      PixelIconKind.search,
      'Dấu chân được ghi lại trên lối đá gần cổng làng.',
    ),
    (
      'Người dẫn đường',
      PixelIconKind.compass,
      'Ghi chép về người gác làng và lời chỉ đường đầu tiên.',
    ),
    (
      'Trang sách mới',
      PixelIconKind.story,
      'Trang mở đầu trong sổ ghi chép hành trình.',
    ),
  ];
  static const _badges = [
    (
      'Bước chân đầu',
      PixelIconKind.coin,
      'Huy hiệu dành cho nhà lữ hành hoàn thành nhiệm vụ đầu tiên.',
    ),
    (
      'Người khám phá',
      PixelIconKind.compass,
      'Huy hiệu minh họa cho việc ghé thăm các địa điểm trong làng.',
    ),
  ];

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Hồ sơ Nhà lữ hành',
    selected: 'profile',
    onNavigate: widget.onNavigate,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        MenuPanel(
          title: 'Thẻ nhà lữ hành',
          light: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              const SizedBox(width: 48, height: 80, child: TravelerPortrait()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    const Text('Nhà lữ hành', style: GameTypography.value),
                    const Text('ID mẫu: 1004527'),
                    const Text('Cấp 12 · EXP 2.340 / 3.600 (65%)'),
                    const PixelProgress(value: .65, label: 'Kinh nghiệm mẫu'),
                    const Text('Nhà sưu tầm trên hành trình mới!'),
                    MenuButton(
                      label: 'Thông tin hồ sơ mẫu',
                      onPressed: () => showSampleDetail(
                        context,
                        'Hồ sơ minh họa',
                        'Nhà lữ hành · ID 1004527. Cấp 12 với 2.340 / 3.600 EXP trong thẻ minh họa.',
                        icon: PixelIconKind.info,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        MenuButton(
          label: 'Mở danh sách yêu thú',
          icon: PixelIconKind.beasts,
          showLabel: true,
          onPressed: () => widget.onNavigate('beasts'),
        ),
        const MenuPanel(
          title: 'Tiến trình hành trình',
          child: MenuGrid(
            minItemWidth: 120,
            maxColumns: 4,
            children: [
              _Stat(PixelIconKind.beasts, 'Yêu thú đã gặp', '28 / 150'),
              _Stat(PixelIconKind.quest, 'Nhiệm vụ hoàn thành', '42'),
              _Stat(PixelIconKind.compass, 'Khu vực khám phá', '3 / 8'),
              _Stat(PixelIconKind.coin, 'Huy hiệu', '5'),
            ],
          ),
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final (index, label) in [
              'Hồ sơ',
              'Sổ sưu tầm',
              'Huy hiệu',
            ].indexed)
              MenuButton.tab(
                label: label,
                selected: _tab == index,
                onPressed: () => setState(() => _tab = index),
              ),
            MenuButton(
              label: 'Mở Cài đặt',
              icon: PixelIconKind.tasks,
              onPressed: () => widget.onNavigate('settings'),
            ),
          ],
        ),
        MenuPanel(
          title: [
            'Nhật ký sưu tầm gần đây',
            'Sổ sưu tầm mẫu',
            'Huy hiệu hành trình',
          ][_tab],
          child: MenuGrid(
            children: [
              for (final (name, icon, detail) in switch (_tab) {
                1 => _collection,
                2 => _badges,
                _ => _collection.take(2),
              })
                MenuButton(
                  label: name,
                  icon: icon,
                  showLabel: true,
                  onPressed: () =>
                      showSampleDetail(context, name, detail, icon: icon),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label, this.value);
  final PixelIconKind icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      PixelIcon(icon, size: 36),
      Text(label, textAlign: TextAlign.center, style: GameTypography.body),
      Text(value, style: GameTypography.value),
    ],
  );
}

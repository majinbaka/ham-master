import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../home/presentation/pixel_icon.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.onNavigate, super.key});
  final ValueChanged<String> onNavigate;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _tab = 0;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Hồ sơ Nhà lữ hành',
    selected: 'profile',
    onNavigate: widget.onNavigate,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        MenuPanel(
          title: 'Nhà lữ hành · ID mẫu: 1004527',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              const PixelIcon(PixelIconKind.beasts, size: 64),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 12,
                  children: [
                    const Text('Cấp 12 · EXP 2.340 / 3.600 (65%)'),
                    Semantics(
                      label: 'Kinh nghiệm mẫu: 65 phần trăm',
                      child: const LinearProgressIndicator(
                        value: .65,
                        minHeight: 10,
                      ),
                    ),
                    const Text('Nhà sưu tầm trên hành trình mới!'),
                    MenuButton(
                      label: 'Thông tin hồ sơ mẫu',
                      onPressed: () => showSampleDetail(
                        context,
                        'Hồ sơ minh họa',
                        'Tên, ID, kinh nghiệm và nhật ký đều là dữ liệu trình bày.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const MenuPanel(
          title: 'Tiến trình hành trình',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Stat(
                  PixelIconKind.beasts,
                  'Yêu thú đã gặp',
                  '28 / 150',
                ),
              ),
              Expanded(
                child: _Stat(PixelIconKind.quest, 'Nhiệm vụ hoàn thành', '42'),
              ),
              Expanded(
                child: _Stat(
                  PixelIconKind.compass,
                  'Khu vực khám phá',
                  '3 / 8',
                ),
              ),
              Expanded(child: _Stat(PixelIconKind.coin, 'Huy hiệu', '5')),
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
              MenuButton(
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
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (name, icon)
                  in (_tab == 2
                      ? const [
                          ('Bước chân đầu', PixelIconKind.coin),
                          ('Người khám phá', PixelIconKind.compass),
                        ]
                      : const [
                          ('Bạn đồng hành', PixelIconKind.beasts),
                          ('Dấu chân nhỏ', PixelIconKind.search),
                          ('Người dẫn đường', PixelIconKind.compass),
                          ('Trang sách mới', PixelIconKind.story),
                        ]))
                MenuButton(
                  label: name,
                  icon: icon,
                  onPressed: () => showSampleDetail(
                    context,
                    name,
                    'Một mục trong nhật ký mẫu của nhà lữ hành.',
                  ),
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
      PixelIcon(icon, size: 32),
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

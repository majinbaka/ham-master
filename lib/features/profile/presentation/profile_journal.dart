import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import '../domain/profile_card.dart';
import 'profile_card_catalog.dart';

class ProfileJournal extends StatefulWidget {
  const ProfileJournal({required this.onNavigate, super.key});

  final ValueChanged<String> onNavigate;

  @override
  State<ProfileJournal> createState() => _ProfileJournalState();
}

class _ProfileJournalState extends State<ProfileJournal> {
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

  static final _badges = [
    for (final badge in ProfileBadge.values)
      (badge.label, badge.icon, badge.description),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 8,
    children: [
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
  );
}

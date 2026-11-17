import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import 'quest_detail.dart';

/// Read-only sample quests using the same controls and density as Home menus.
class QuestScreen extends StatelessWidget {
  const QuestScreen({required this.onBack, this.onNavigate, super.key});
  final VoidCallback onBack;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Nhiệm vụ',
    selected: 'quests',
    onNavigate: onNavigate ?? (_) => onBack(),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        _CategoryTabs(),
        MenuColumns(leading: _ChapterList(), detail: QuestDetail()),
      ],
    ),
  );
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 4,
    runSpacing: 4,
    children: [
      for (final (index, label) in const [
        'Chính truyện',
        'Phụ',
        'Hàng ngày',
        'Thành tựu',
      ].indexed)
        MenuButton(label: label, selected: index == 0, onPressed: null),
    ],
  );
}

class _ChapterList extends StatelessWidget {
  const _ChapterList();
  @override
  Widget build(BuildContext context) => MenuPanel(
    title: 'Danh sách chương',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        const MenuButton(
          label: 'Chương 1\nKhởi hành',
          icon: PixelIconKind.story,
          showLabel: true,
          selected: true,
          onPressed: null,
        ),
        ExpansionTile(
          title: const Text('3 chương đã khóa'),
          children: [
            MenuGrid(
              children: [
                for (final (index, name) in const [
                  'Bên kia đồi',
                  'Lối mòn cũ',
                  'Chân trời mới',
                ].indexed)
                  MenuButton(
                    label: 'Chương ${index + 2}\n$name\nĐã khóa',
                    icon: PixelIconKind.lock,
                    showLabel: true,
                    onPressed: null,
                  ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import 'quest_detail.dart';

enum QuestCategory {
  main('Chính truyện'),
  side('Phụ'),
  daily('Hàng ngày'),
  achievements('Thành tựu');

  const QuestCategory(this.label);

  final String label;
}

/// Read-only sample quests using the same controls and density as Home menus.
class QuestScreen extends StatefulWidget {
  const QuestScreen({
    required this.onBack,
    this.onNavigate,
    this.initialCategory = QuestCategory.main,
    super.key,
  });

  final VoidCallback onBack;
  final ValueChanged<String>? onNavigate;
  final QuestCategory initialCategory;

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  late var _category = widget.initialCategory;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Nhiệm vụ',
    selected: 'quests',
    onNavigate: widget.onNavigate ?? (_) => widget.onBack(),
    onBack: widget.onBack,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final category in QuestCategory.values)
              MenuButton.tab(
                label: category.label,
                selected: _category == category,
                onPressed: () => setState(() => _category = category),
              ),
          ],
        ),
        switch (_category) {
          QuestCategory.main => const MenuColumns(
            leading: _ChapterList(),
            detail: QuestDetail(),
          ),
          QuestCategory.side => const MenuPanel(
            title: 'Nhiệm vụ phụ',
            light: true,
            child: Text('Chưa có nhiệm vụ phụ.'),
          ),
          QuestCategory.daily => const MenuPanel(
            title: 'Nhiệm vụ hàng ngày',
            light: true,
            child: Text('Chưa có nhiệm vụ hàng ngày.'),
          ),
          QuestCategory.achievements => MenuPanel(
            title: 'Thành tựu',
            child: MenuButton(
              label: 'Bước chân đầu',
              icon: PixelIconKind.coin,
              showLabel: true,
              onPressed: () => showSampleDetail(
                context,
                'Bước chân đầu',
                'Huy hiệu dành cho nhà lữ hành hoàn thành nhiệm vụ đầu tiên.',
                icon: PixelIconKind.coin,
              ),
            ),
          ),
        },
      ],
    ),
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
        MenuButton(
          label: 'Chương 1\nKhởi hành',
          icon: PixelIconKind.story,
          showLabel: true,
          selected: true,
          onPressed: () => showSampleDetail(
            context,
            'Chương 1: Khởi hành',
            'Bước chân đầu tiên · Đang thực hiện (1 / 3 mục tiêu).',
            icon: PixelIconKind.story,
          ),
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
                    onPressed: () => showSampleDetail(
                      context,
                      name,
                      'Hoàn thành nhiệm vụ chương ${index + 1} để mở chương này.',
                      icon: PixelIconKind.lock,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

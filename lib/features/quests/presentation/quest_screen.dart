import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../home/presentation/pixel_frame.dart';
import '../../home/presentation/pixel_icon.dart';
import 'quest_detail.dart';

/// A preview of the quest layout using presentation-only sample content.
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
      spacing: 8,
      children: [
        _CategoryTabs(),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 6,
            children: [
              Expanded(flex: 38, child: _ChapterList()),
              Expanded(flex: 62, child: QuestDetail()),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) => Row(
    spacing: 4,
    children: [
      for (final (index, label) in const [
        'Chính truyện',
        'Phụ',
        'Hàng ngày',
        'Thành tựu',
      ].indexed)
        Expanded(
          child: Semantics(
            selected: index == 0,
            enabled: index == 0,
            child: PixelFrame(
              skin: index == 0 ? PixelFrameSkin.selected : PixelFrameSkin.cream,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 32,
                child: PixelLabel(
                  label,
                  fontSize: 13,
                  color: index == 0
                      ? PixelUiColors.outline
                      : PixelUiColors.paper,
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

class _ChapterList extends StatelessWidget {
  const _ChapterList();

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        for (final (index, name) in const [
          'Khởi hành',
          'Bên kia đồi',
          'Lối mòn cũ',
          'Chân trời mới',
        ].indexed)
          Semantics(
            selected: index == 0,
            label: index == 0 ? null : 'Đã khóa',
            child: PixelFrame(
              skin: index == 0 ? PixelFrameSkin.gold : PixelFrameSkin.cool,
              padding: EdgeInsets.zero,
              child: Row(
                spacing: 2,
                children: [
                  PixelIcon(
                    index == 0 ? PixelIconKind.story : PixelIconKind.lock,
                    size: 21,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'Chương ${index + 1}\n$name',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

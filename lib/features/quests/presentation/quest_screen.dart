import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import '../../home/presentation/pixel_frame.dart';
import '../../home/presentation/pixel_icon.dart';
import 'quest_detail.dart';

/// A preview of the quest layout using presentation-only sample content.
class QuestScreen extends StatelessWidget {
  const QuestScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF12101C),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        const _PreviewHud(),
                        Row(
                          spacing: 8,
                          children: [
                            PixelFrame(
                              padding: EdgeInsets.zero,
                              child: IconButton(
                                tooltip: 'Quay lại',
                                onPressed: onBack,
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),
                            const Expanded(
                              child: PixelFrame(
                                skin: PixelFrameSkin.gold,
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  spacing: 6,
                                  children: [
                                    PixelIcon(PixelIconKind.quest, size: 26),
                                    Flexible(child: Text('Nhiệm vụ')),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const _CategoryTabs(),
                        const IntrinsicHeight(
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
                  ),
                ),
                const SizedBox(height: 8),
                _QuestNavigation(onHome: onBack),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _PreviewHud extends StatelessWidget {
  const _PreviewHud();

  @override
  Widget build(BuildContext context) => const Row(
    spacing: 4,
    children: [
      Expanded(
        flex: 4,
        child: PixelFrame(
          skin: PixelFrameSkin.cool,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 36,
            child: Column(
              children: [
                Expanded(child: PixelLabel('Nhà lữ hành', fontSize: 13)),
                Expanded(child: PixelLabel('Cấp 1 · EXP 0/100', fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
      Expanded(flex: 2, child: _Resource(PixelIconKind.coin, 'Vàng', '100')),
      Expanded(flex: 2, child: _Resource(PixelIconKind.gem, 'Ngọc', '20')),
      Expanded(
        flex: 2,
        child: _Resource(PixelIconKind.energy, 'Năng lượng', '30/30'),
      ),
    ],
  );
}

class _Resource extends StatelessWidget {
  const _Resource(this.icon, this.label, this.value);

  final PixelIconKind icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value',
    excludeSemantics: true,
    child: PixelFrame(
      skin: PixelFrameSkin.cool,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PixelIcon(icon, size: 17),
            Flexible(child: PixelLabel(value, fontSize: 12)),
          ],
        ),
      ),
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

class _QuestNavigation extends StatelessWidget {
  const _QuestNavigation({required this.onHome});

  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: EdgeInsets.zero,
    child: Row(
      children: [
        for (final (index, (icon, label)) in const [
          (PixelIconKind.home, 'Trang chủ'),
          (PixelIconKind.compass, 'Khám phá'),
          (PixelIconKind.backpack, 'Túi đồ'),
          (PixelIconKind.beasts, 'Đội hình'),
          (PixelIconKind.quest, 'Nhiệm vụ'),
          (PixelIconKind.coin, 'Cửa hàng'),
        ].indexed)
          Expanded(
            child: SizedBox(height: 48, child: _slot(index, icon, label)),
          ),
      ],
    ),
  );

  Widget _slot(int index, PixelIconKind icon, String label) {
    final selected = index == 4;
    final content = Column(
      children: [
        PixelIcon(icon, size: 23),
        Expanded(
          child: PixelLabel(
            label,
            fontSize: 11,
            color: selected ? PixelUiColors.outline : PixelUiColors.paper,
          ),
        ),
      ],
    );
    const padding = EdgeInsets.all(4);
    if (index == 0) {
      return TextButton(
        onPressed: onHome,
        style: TextButton.styleFrom(padding: padding),
        child: content,
      );
    }
    return Semantics(
      selected: selected,
      enabled: selected,
      child: selected
          ? PixelFrame(
              skin: PixelFrameSkin.selected,
              padding: EdgeInsets.zero,
              child: content,
            )
          : Padding(padding: padding, child: content),
    );
  }
}

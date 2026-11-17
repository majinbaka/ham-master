import 'package:flutter/material.dart';

import '../../../app/theme/game_typography.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

/// Read-only objectives and rewards for the selected sample chapter.
class QuestDetail extends StatelessWidget {
  const QuestDetail({super.key});

  @override
  Widget build(BuildContext context) => MenuPanel(
    title: 'Chương 1: Khởi hành',
    light: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        const MenuPreview(icon: PixelIconKind.story),
        const Text('Bước chân đầu tiên', style: GameTypography.heading),
        const Text('Ghé trại và tìm đường tới cổng làng. (Dữ liệu mẫu)'),
        const Text('Mục tiêu', style: GameTypography.heading),
        for (final (done, label) in const [
          (true, 'Ghé trại (1/1)'),
          (false, 'Tìm cổng làng (0/1)'),
          (false, 'Báo lại người gác (0/1)'),
        ])
          Row(
            spacing: 4,
            children: [
              Icon(
                done ? Icons.check_box : Icons.check_box_outline_blank,
                size: 16,
                color: PixelUiColors.outline,
              ),
              Expanded(child: Text(label)),
            ],
          ),
        const Text('Phần thưởng', style: GameTypography.heading),
        MenuGrid(
          minItemWidth: 60,
          maxColumns: 4,
          children: [
            for (final (icon, label, value) in const [
              (PixelIconKind.story, 'Kinh nghiệm', '50'),
              (PixelIconKind.coin, 'Vàng', '100'),
              (PixelIconKind.gem, 'Ngọc', '5'),
              (PixelIconKind.energy, 'Năng lượng', '2'),
            ])
              Semantics(
                label: '$label: $value',
                excludeSemantics: true,
                child: Column(
                  children: [PixelIcon(icon, size: 36), Text(value)],
                ),
              ),
          ],
        ),
        const Text(
          'Đang thực hiện',
          textAlign: TextAlign.center,
          style: GameTypography.heading,
        ),
      ],
    ),
  );
}

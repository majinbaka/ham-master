import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import '../../home/presentation/pixel_frame.dart';
import '../../home/presentation/pixel_icon.dart';

/// Read-only objectives and rewards for the selected sample chapter.
class QuestDetail extends StatelessWidget {
  const QuestDetail({super.key});

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.paper,
    padding: const EdgeInsets.all(4),
    child: DefaultTextStyle.merge(
      style: const TextStyle(color: PixelUiColors.outline, fontSize: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          const PixelFrame(
            skin: PixelFrameSkin.cool,
            padding: EdgeInsets.zero,
            child: AspectRatio(
              aspectRatio: 3,
              child: Center(child: PixelIcon(PixelIconKind.story, size: 36)),
            ),
          ),
          const PixelFrame(
            skin: PixelFrameSkin.gold,
            padding: EdgeInsets.zero,
            child: Text(
              'Chương 1: Khởi hành',
              textAlign: TextAlign.center,
              style: TextStyle(color: PixelUiColors.paper),
            ),
          ),
          const _SectionTitle('Bước chân đầu tiên'),
          const Text('Ghé trại và tìm đường tới cổng làng. (Dữ liệu mẫu)'),
          const Divider(height: 4, color: PixelUiColors.cool),
          const _SectionTitle('Mục tiêu'),
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
          const Divider(height: 4, color: PixelUiColors.cool),
          const _SectionTitle('Phần thưởng'),
          Row(
            spacing: 3,
            children: [
              for (final (icon, label, value) in const [
                (PixelIconKind.story, 'Kinh nghiệm', '50'),
                (PixelIconKind.coin, 'Vàng', '100'),
                (PixelIconKind.gem, 'Ngọc', '5'),
                (PixelIconKind.energy, 'Năng lượng', '2'),
              ])
                Expanded(
                  child: Semantics(
                    label: '$label: $value',
                    excludeSemantics: true,
                    child: PixelFrame(
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        height: 38,
                        child: Column(
                          children: [
                            PixelIcon(icon, size: 20),
                            Expanded(child: PixelLabel(value, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 4, color: PixelUiColors.cool),
          const PixelFrame(
            skin: PixelFrameSkin.cool,
            padding: EdgeInsets.zero,
            child: Text(
              'Đang thực hiện',
              textAlign: TextAlign.center,
              style: TextStyle(color: PixelUiColors.paper),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) =>
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold));
}

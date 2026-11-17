import 'package:flutter/material.dart';

import '../../features/home/presentation/pixel_frame.dart';
import '../../features/home/presentation/pixel_icon.dart';
import '../../features/home/presentation/pixel_frame_skin.dart'
    show PixelFrameArtwork;
import '../theme/pixel_ui_colors.dart';

/// Presentation-only menu destinations; the app router owns navigation.
const menuDestinations = [
  ('home', 'Trang chủ', PixelIconKind.home),
  ('story', 'Cốt truyện', PixelIconKind.story),
  ('quests', 'Nhiệm vụ', PixelIconKind.quest),
  ('shop', 'Cửa hàng', PixelIconKind.coin),
  ('profile', 'Hồ sơ', PixelIconKind.beasts),
  ('settings', 'Cài đặt', PixelIconKind.tasks),
];

class MenuShell extends StatelessWidget {
  const MenuShell({
    required this.title,
    required this.selected,
    required this.onNavigate,
    required this.child,
    super.key,
  });

  final String title;
  final String selected;
  final ValueChanged<String> onNavigate;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PixelUiColors.outline,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 10,
                      children: [
                        const _SampleHud(),
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'Quay lại',
                              onPressed: () => onNavigate('home'),
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Expanded(
                              child: PixelFrame(
                                skin: PixelFrameSkin.gold,
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'BẢN XEM TRƯỚC · Dữ liệu mẫu · Không lưu thay đổi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: PixelUiColors.cool,
                            fontSize: 12,
                          ),
                        ),
                        child,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                PixelFrame(
                  skin: PixelFrameSkin.cool,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      for (final (route, label, icon) in menuDestinations)
                        Expanded(
                          child: Semantics(
                            selected: route == selected,
                            child: Stack(
                              children: [
                                if (route == selected)
                                  const Positioned.fill(
                                    child: PixelFrameArtwork(
                                      skin: PixelFrameSkin.selected,
                                    ),
                                  ),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(48, 52),
                                      foregroundColor: route == selected
                                          ? PixelUiColors.outline
                                          : PixelUiColors.paper,
                                    ),
                                    onPressed: () => onNavigate(route),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        PixelIcon(icon, size: 22),
                                        SizedBox(
                                          height: 22,
                                          child: FittedBox(child: Text(label)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _SampleHud extends StatelessWidget {
  const _SampleHud();

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.cool,
    padding: const EdgeInsets.all(6),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 4,
      children: [
        const Text('Nhà lữ hành · Cấp 12'),
        for (final (icon, value) in const [
          (PixelIconKind.coin, '48.720'),
          (PixelIconKind.gem, '1.280'),
          (PixelIconKind.energy, '120/120'),
        ])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [PixelIcon(icon, size: 22), Text(value)],
          ),
      ],
    ),
  );
}

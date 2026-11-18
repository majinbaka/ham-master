import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

class HomeUtilities extends StatelessWidget {
  const HomeUtilities({
    required this.gap,
    required this.onInformation,
    super.key,
  });

  final double gap;
  final VoidCallback onInformation;

  @override
  Widget build(BuildContext context) => Row(
    spacing: gap,
    children: [
      for (final (icon, label, onPressed) in [
        (
          PixelIconKind.mail,
          'Hộp thư',
          () => showSampleDetail(
            context,
            'Hộp thư',
            'Chưa có thư. Thông báo hành trình sẽ xuất hiện tại đây.',
            icon: PixelIconKind.mail,
          ),
        ),
        (PixelIconKind.info, 'Thông tin màn hình', onInformation),
      ])
        Expanded(
          child: MenuButton(
            label: label,
            icon: icon,
            artworkScale: 2 / 3,
            onPressed: onPressed,
          ),
        ),
    ],
  );
}

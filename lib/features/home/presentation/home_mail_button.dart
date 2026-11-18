import 'package:flutter/material.dart';

import '../../../app/presentation/pixel/pixel_icon.dart';
import '../../../app/presentation/sample_detail_dialog.dart';

class HomeMailButton extends StatelessWidget {
  const HomeMailButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Hộp thư',
    style: IconButton.styleFrom(
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(),
      minimumSize: const Size.square(48),
    ),
    onPressed: () => showSampleDetail(
      context,
      'Hộp thư',
      'Chưa có thư. Thông báo hành trình sẽ xuất hiện tại đây.',
      icon: PixelIconKind.mail,
    ),
    icon: const PixelIcon(PixelIconKind.mail, size: 32),
  );
}

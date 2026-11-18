import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

/// Home and menus render copy at logical sizes, independently of artwork.
class HomeQuests extends StatelessWidget {
  const HomeQuests({this.onOpen, this.onOpenSide, super.key});
  final VoidCallback? onOpen;
  final VoidCallback? onOpenSide;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 8,
    children: [
      _QuestLink(
        title: 'Nhiệm vụ chính',
        label: 'Mở Nhiệm vụ',
        detail: onOpen == null ? 'Chưa có nhiệm vụ' : 'Xem nhiệm vụ',
        onOpen: onOpen,
      ),
      _QuestLink(
        title: 'Nhiệm vụ phụ',
        label: 'Mở Nhiệm vụ phụ',
        detail: onOpenSide == null
            ? 'Chưa có nhiệm vụ phụ'
            : 'Xem nhiệm vụ phụ',
        onOpen: onOpenSide,
      ),
    ],
  );
}

class _QuestLink extends StatelessWidget {
  const _QuestLink({
    required this.title,
    required this.detail,
    required this.label,
    required this.onOpen,
  });

  final String title;
  final String detail;
  final String label;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final panel = MenuPanel(title: title, child: Text(detail));
    if (onOpen == null) return panel;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        child: InkWell(onTap: onOpen, child: panel),
      ),
    );
  }
}

class HomeUtilities extends StatelessWidget {
  const HomeUtilities({
    required this.gap,
    required this.onInformation,
    this.onDailyQuests,
    super.key,
  });

  final double gap;
  final VoidCallback onInformation;
  final VoidCallback? onDailyQuests;

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
        (PixelIconKind.tasks, 'Nhiệm vụ hàng ngày', onDailyQuests),
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

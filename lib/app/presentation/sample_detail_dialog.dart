import 'package:flutter/material.dart';

import 'menu_button.dart';
import 'pixel/pixel_icon.dart';

Future<void> showSampleDetail(
  BuildContext context,
  String title,
  String detail, {
  PixelIconKind? icon,
  String note = 'Dữ liệu mẫu · Không lưu thay đổi',
  String closeLabel = 'Đóng',
}) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    scrollable: true,
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (icon != null) PixelIcon(icon, size: 48),
        Text(detail),
        if (note.isNotEmpty)
          Text(note, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
    actions: [
      MenuButton(
        label: closeLabel,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);

import 'package:flutter/material.dart';

import '../../features/home/presentation/pixel_frame.dart';
import '../../features/home/presentation/pixel_icon.dart';
import '../theme/pixel_ui_colors.dart';

class MenuPanel extends StatelessWidget {
  const MenuPanel({required this.child, this.title, super.key});
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) => PixelFrame(
    skin: PixelFrameSkin.paper,
    padding: const EdgeInsets.all(10),
    child: DefaultTextStyle.merge(
      style: const TextStyle(color: PixelUiColors.outline),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          child,
        ],
      ),
    ),
  );
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.icon,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final PixelIconKind? icon;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: PixelFrame(
      skin: selected ? PixelFrameSkin.selected : PixelFrameSkin.cream,
      padding: EdgeInsets.zero,
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: selected
              ? PixelUiColors.outline
              : PixelUiColors.paper,
          disabledForegroundColor: PixelUiColors.cool,
          padding: const EdgeInsets.all(8),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) PixelIcon(icon!, size: 24),
            if (icon != null) const SizedBox(width: 4),
            Flexible(child: Text(label, textAlign: TextAlign.center)),
          ],
        ),
      ),
    ),
  );
}

void showSampleDetail(BuildContext context, String title, String detail) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Text(
          '$detail\n\nDữ liệu mẫu. Chưa thực hiện giao dịch hoặc cập nhật tiến trình.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}

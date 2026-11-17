import 'package:flutter/material.dart';

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

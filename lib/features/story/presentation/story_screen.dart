import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../home/presentation/pixel_frame.dart';
import '../../home/presentation/pixel_icon.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({
    required this.onNavigate,
    required this.onStart,
    super.key,
  });
  final ValueChanged<String> onNavigate;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Cốt truyện',
    selected: 'story',
    onNavigate: onNavigate,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Expanded(
          flex: 34,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              for (final (index, title) in const [
                'Khởi hành',
                'Bên kia đồi',
                'Lối mòn cũ',
                'Chân trời mới',
                'Lời kết',
              ].indexed)
                MenuButton(
                  label:
                      'Chương ${index + 1}\n$title${index == 0 ? '' : '\nĐã khóa'}',
                  icon: index == 0 ? PixelIconKind.story : PixelIconKind.lock,
                  selected: index == 0,
                  onPressed: index == 0 ? () => onNavigate('story') : null,
                ),
            ],
          ),
        ),
        Expanded(
          flex: 66,
          child: MenuPanel(
            title: 'Chương 1: Khởi hành',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                const PixelFrame(
                  skin: PixelFrameSkin.cool,
                  child: AspectRatio(
                    aspectRatio: 2.2,
                    child: Center(
                      child: PixelIcon(PixelIconKind.story, size: 56),
                    ),
                  ),
                ),
                const Text(
                  'Một lời nhắn từ người gác làng mở đầu hành trình. Ghé trại, tìm đường tới cổng làng và gặp người bạn đồng hành.',
                ),
                const Text(
                  'Tiến độ chương · 0 / 5',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (final (index, title) in const [
                  'Lời nhắn đầu tiên',
                  'Dấu vết bên đường',
                  'Cuộc gặp bất ngờ',
                  'Qua ngọn đồi',
                  'Hướng đi tiếp theo',
                ].indexed)
                  MenuButton(
                    label:
                        '${index + 1}. $title${index == 0 ? '' : ' · Đã khóa'}',
                    icon: index == 0 ? PixelIconKind.talk : PixelIconKind.lock,
                    selected: index == 0,
                    onPressed: index == 0 ? onStart : null,
                  ),
                MenuButton(
                  label: 'Bắt đầu xem thử',
                  selected: true,
                  onPressed: onStart,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// An episode preview, without unlocking or advancing any game state.
class StoryEpisodeScreen extends StatelessWidget {
  const StoryEpisodeScreen({required this.onBack, super.key});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Về Cốt truyện',
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Lời nhắn đầu tiên'),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MenuPanel(
          title: 'Bản xem trước hội thoại',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              const PixelIcon(PixelIconKind.talk, size: 64),
              const Text(
                'Người gác làng: Chào nhà lữ hành! Hãy ghé trại trước khi lên đường. Người bạn đồng hành đang đợi bạn ở đó.',
              ),
              const Text(
                'Đây là nội dung minh họa. Chưa có gameplay hoặc phần thưởng; tiến độ chương vẫn là 0/5.',
              ),
              MenuButton(label: 'Về danh sách chương', onPressed: onBack),
            ],
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import '../../../app/theme/game_typography.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';

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
    child: MenuColumns(
      leading: MenuGrid(
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
      detail: MenuPanel(
        title: 'Chương 1: Khởi hành',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            const MenuPreview(icon: PixelIconKind.story),
            const Text(
              'Một lời nhắn từ người gác làng mở đầu hành trình. Ghé trại, tìm đường tới cổng làng và gặp người bạn đồng hành.',
            ),
            const Text('Tiến độ chương · 0 / 5', style: GameTypography.heading),
            for (final (index, title) in const [
              'Lời nhắn đầu tiên',
              'Dấu vết bên đường',
              'Cuộc gặp bất ngờ',
              'Qua ngọn đồi',
              'Hướng đi tiếp theo',
            ].indexed)
              MenuButton(
                label: '${index + 1}. $title${index == 0 ? '' : ' · Đã khóa'}',
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
  );
}

/// An episode preview, without unlocking or advancing any game state.
class StoryEpisodeScreen extends StatelessWidget {
  const StoryEpisodeScreen({required this.onBack, this.onNavigate, super.key});
  final VoidCallback onBack;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Lời nhắn đầu tiên',
    selected: 'story',
    onNavigate: onNavigate ?? (_) => onBack(),
    onBack: onBack,
    backLabel: 'Về Cốt truyện',
    child: MenuPanel(
      title: 'Bản xem trước hội thoại',
      light: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          const PixelIcon(PixelIconKind.talk, size: 48),
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
  );
}

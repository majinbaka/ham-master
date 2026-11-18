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
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          MenuButton(
            label: 'Chương 1\nKhởi hành',
            icon: PixelIconKind.story,
            showLabel: true,
            selected: true,
            onPressed: () => showSampleDetail(
              context,
              'Chương 1: Khởi hành',
              'Chương mở đầu · 0 / 5 đoạn truyện.',
              icon: PixelIconKind.story,
            ),
          ),
          ExpansionTile(
            title: const Text('4 chương chưa mở'),
            children: [
              MenuGrid(
                children: [
                  for (final (index, title) in const [
                    'Bên kia đồi',
                    'Lối mòn cũ',
                    'Chân trời mới',
                    'Lời kết',
                  ].indexed)
                    MenuButton(
                      label: 'Chương ${index + 2}\n$title\nĐã khóa',
                      showLabel: true,
                      icon: PixelIconKind.lock,
                      onPressed: () => showSampleDetail(
                        context,
                        title,
                        'Hoàn thành chương ${index + 1} để mở chương này.',
                        icon: PixelIconKind.lock,
                      ),
                    ),
                ],
              ),
            ],
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
            const PixelProgress(value: 0, label: 'Tiến độ chương mẫu'),
            for (final (index, title) in const [
              'Lời nhắn đầu tiên',
              'Dấu vết bên đường',
              'Cuộc gặp bất ngờ',
              'Qua ngọn đồi',
              'Hướng đi tiếp theo',
            ].indexed)
              MenuButton(
                label: '${index + 1}. $title${index == 0 ? '' : ' · Đã khóa'}',
                showLabel: true,
                icon: index == 0 ? PixelIconKind.talk : PixelIconKind.lock,
                selected: index == 0,
                onPressed: index == 0
                    ? onStart
                    : () => showSampleDetail(
                        context,
                        title,
                        'Xem xong đoạn truyện $index để mở đoạn này.',
                        icon: PixelIconKind.lock,
                      ),
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        const MenuPreview(icon: PixelIconKind.talk),
        const MenuPanel(
          title: 'Người gác làng',
          light: true,
          child: Text(
            'Chào nhà lữ hành! Hãy ghé trại trước khi lên đường. Người bạn đồng hành đang đợi bạn ở đó.',
          ),
        ),
        const MenuPanel(
          title: 'Trang đầu hành trình',
          child: Text(
            'Đây là nội dung minh họa. Chưa có gameplay hoặc phần thưởng; tiến độ chương vẫn là 0/5.',
          ),
        ),
        MenuButton(label: 'Về danh sách chương', onPressed: onBack),
      ],
    ),
  );
}

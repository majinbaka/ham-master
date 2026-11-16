import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'pixel_frame.dart';
import 'pixel_icon.dart';

/// Quest panels always stay stacked at the left edge, as in the reference.
class HomeQuests extends StatelessWidget {
  const HomeQuests({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 450,
        height: 170,
        child: _QuestPanel(
          title: 'Nhiệm vụ chính',
          message: 'Chưa có nhiệm vụ',
          accent: PixelUiColors.gold,
          icon: PixelIconKind.quest,
        ),
      ),
      SizedBox(height: 16),
      SizedBox(
        width: 414,
        height: 118,
        child: _QuestPanel(
          title: 'Nhiệm vụ phụ',
          message: 'Chưa có nhiệm vụ phụ',
          accent: PixelUiColors.cyan,
          icon: PixelIconKind.bookmark,
        ),
      ),
    ],
  );
}

class HomeMinimap extends StatelessWidget {
  const HomeMinimap({super.key});

  @override
  Widget build(BuildContext context) => PixelFrame(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 38, child: PixelLabel('BẢN ĐỒ', fontSize: 27)),
        const SizedBox(height: 8),
        Expanded(
          child: Semantics(
            label: 'Bản đồ chưa mở',
            child: const ColoredBox(
              color: Colors.black,
              child: Center(child: PixelIcon(PixelIconKind.lock, size: 36)),
            ),
          ),
        ),
      ],
    ),
  );
}

class _QuestPanel extends StatelessWidget {
  const _QuestPanel({
    required this.title,
    required this.message,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String message;
  final Color accent;
  final PixelIconKind icon;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        top: 26,
        child: PixelFrame(
          skin: accent == PixelUiColors.gold
              ? PixelFrameSkin.gold
              : PixelFrameSkin.cyan,
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: PixelLabel(
              message,
              fontSize: 28,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      Positioned(
        left: 12,
        top: 0,
        width: 300,
        height: 52,
        child: PixelFrame(
          skin: accent == PixelUiColors.gold
              ? PixelFrameSkin.gold
              : PixelFrameSkin.cyan,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              PixelIcon(icon, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: PixelLabel(
                  title,
                  color: accent,
                  fontSize: 27,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class HomeUtilities extends StatelessWidget {
  const HomeUtilities({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final icon in const [
        PixelIconKind.mail,
        PixelIconKind.tasks,
        PixelIconKind.info,
      ])
        Expanded(
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: PixelFrame(
                skin: PixelFrameSkin.cool,
                padding: const EdgeInsets.all(8),
                child: PixelIcon(icon, size: 42),
              ),
            ),
          ),
        ),
    ],
  );
}

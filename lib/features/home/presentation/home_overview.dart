import 'package:flutter/material.dart';

import '../../../app/theme/pixel_ui_colors.dart';
import 'home_spacing.dart';
import 'pixel_frame.dart';
import 'pixel_icon.dart';

/// Quest panels always stay stacked at the left edge, as in the reference.
class HomeQuests extends StatelessWidget {
  const HomeQuests({this.onOpen, super.key});

  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 440,
        height: 160,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _QuestPanel(
              title: 'Nhiệm vụ chính',
              message: onOpen == null ? 'Chưa có nhiệm vụ' : 'Xem nhiệm vụ',
              accent: PixelUiColors.gold,
              icon: PixelIconKind.quest,
            ),
            if (onOpen != null)
              Positioned.fill(
                child: Tooltip(
                  message: 'Mở Nhiệm vụ',
                  child: Semantics(
                    label: 'Mở Nhiệm vụ',
                    child: TextButton(
                      onPressed: onOpen,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: HomeSpacing.gap),
      const SizedBox(
        width: 414,
        height: 100,
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
    padding: const EdgeInsets.all(HomeSpacing.small),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 38, child: PixelLabel('BẢN ĐỒ', fontSize: 27)),
        const SizedBox(height: HomeSpacing.small),
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PixelIcon(icon, size: 32),
                const SizedBox(width: HomeSpacing.small),
                Flexible(
                  child: PixelLabel(
                    title,
                    color: accent,
                    fontSize: 27,
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
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
    spacing: HomeSpacing.small,
    children: [
      for (final icon in const [
        PixelIconKind.mail,
        PixelIconKind.tasks,
        PixelIconKind.info,
      ])
        Expanded(
          child: ExcludeSemantics(
            child: PixelFrame(
              skin: PixelFrameSkin.cool,
              padding: const EdgeInsets.all(HomeSpacing.small),
              child: Center(child: PixelIcon(icon, size: 40)),
            ),
          ),
        ),
    ],
  );
}

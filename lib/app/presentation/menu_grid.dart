import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Even content slots; large text reduces the column count before copy is cramped.
class MenuGrid extends StatelessWidget {
  const MenuGrid({
    required this.children,
    this.minItemWidth = 140,
    this.maxColumns = 2,
    super.key,
  });
  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final textScale = MediaQuery.textScalerOf(context).scale(13) / 13;
      var columns = math.max(
        1,
        math.min(
          maxColumns,
          ((constraints.maxWidth + 8) / (minItemWidth * textScale + 8)).floor(),
        ),
      );
      // Avoid a solitary fourth stat beneath a three-column row.
      if (children.length == 4 && columns == 3) columns = 2;
      return Column(
        spacing: 8,
        children: [
          for (var start = 0; start < children.length; start += columns)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  for (var column = 0; column < columns; column++)
                    Expanded(
                      child: start + column < children.length
                          ? children[start + column]
                          : const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
        ],
      );
    },
  );
}

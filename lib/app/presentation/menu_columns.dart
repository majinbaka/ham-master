import 'package:flutter/material.dart';

/// Master/detail menus stack before either column becomes too narrow for copy.
class MenuColumns extends StatelessWidget {
  const MenuColumns({required this.leading, required this.detail, super.key});

  final Widget leading;
  final Widget detail;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
      if (constraints.maxWidth < 600 * textScale) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [leading, detail],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Expanded(flex: 1, child: leading),
          Expanded(flex: 2, child: detail),
        ],
      );
    },
  );
}

import 'package:flutter/widgets.dart';

enum BattleMove {
  flame('Bùng Lửa', 'flame', 'Luồng lửa lao thẳng về phía mục tiêu.'),
  heat('Hơi Nóng', 'heat', 'Một luồng khí xoáy hướng về phía trước.'),
  claw('Cào Xé', 'claw', 'Ba vệt móng vuốt ở cự ly gần.'),
  speed('Tăng Tốc', 'speed', 'Hỏa Hổ chuẩn bị di chuyển nhanh hơn.');

  const BattleMove(this.label, this._assetName, this.description);

  final String label;
  final String _assetName;
  final String description;

  Widget get artwork => Image.asset(
    'assets/sprites/move-$_assetName.png',
    width: 36,
    height: 36,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.none,
    excludeFromSemantics: true,
  );
}

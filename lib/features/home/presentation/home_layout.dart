import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Reference artwork dimensions, projected using one orientation-invariant scale.
/// Rotating a device changes anchors and empty scene space, never frame sizes.
class HomeLayout {
  HomeLayout(Size viewport, {double? deviceShortSide})
    : scale = math.min(
        math.min((deviceShortSide ?? viewport.shortestSide) / 940, 390 / 940),
        viewport.width / 940,
      ),
      viewport = viewport;

  final Size viewport;
  final double scale;

  double get _width => viewport.width / scale;
  double get _height => viewport.height / scale;
  bool get _roomBesideFooter => _width >= 1790;

  Rect get profile => _rect(0, 0, 470, 118);
  Rect get resources => _rect(_width - 458, 6, 448, 108);
  Rect get quests => _rect(12, _tight ? 124 : 146, 450, 304);
  Rect get utilities => _rect(_width - 298, 140, 288, 70);
  Rect get minimap => _rect(_width - 330, 220, 320, 216);
  Rect get navigation => _rect((_width - 940) / 2, _height - 184, 940, 176);

  // Tight gaps on short, narrow windows preserve all component dimensions.
  bool get _tight => !_roomBesideFooter && _height < 1200;
  double get _actionBottom => _tight ? 196 : 264;
  double get _dialogueBottom => _tight ? 332 : 424;

  Rect get actions =>
      _rect((_width - 840) / 2, _height - _actionBottom - 124, 840, 124);
  Rect get dialogue =>
      _rect((_width - 866) / 2, _height - _dialogueBottom - 176, 866, 176);

  Rect get character {
    final top = _width > _height ? 20.0 : 450.0;
    final bottom = _height - _dialogueBottom - 176;
    final centerY = top + (bottom - top) * 0.65;
    return _rect((_width - 72) / 2, centerY - 64, 72, 128);
  }

  Rect _rect(double x, double y, double width, double height) =>
      Rect.fromLTWH(x * scale, y * scale, width * scale, height * scale);
}

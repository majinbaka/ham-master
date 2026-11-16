import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'home_spacing.dart';

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

  static const _edge = HomeSpacing.edge;
  static const _gap = HomeSpacing.gap;

  Rect get profile => _rect(_edge, _edge, 440, 120);
  Rect get resources => _rect(_width - _edge - 420, _edge, 420, 120);
  Rect get quests => _rect(_edge, profile.bottom / scale + _gap, 440, 280);
  Rect get utilities =>
      _rect(_width - _edge - 280, resources.bottom / scale + _gap, 280, 80);
  Rect get minimap =>
      _rect(_width - _edge - 320, utilities.bottom / scale + _gap, 320, 216);
  Rect get navigation =>
      _rect((_width - 900) / 2, _height - _edge - 160, 900, 160);

  // Half-grid gaps keep the centered footer clear of side panels on short
  // landscape windows, without changing any component's size on rotation.
  bool get _tight => !_roomBesideFooter && _height < 1200;
  double get _footerGap => _tight ? HomeSpacing.small : _gap;

  Rect get actions => _rect(
    (_width - 840) / 2,
    navigation.top / scale - _footerGap - 120,
    840,
    120,
  );
  Rect get dialogue => _rect(
    (_width - 860) / 2,
    actions.top / scale - _footerGap - 160,
    860,
    160,
  );

  Rect get character {
    final top = _width > _height ? 20.0 : minimap.bottom / scale + _gap;
    final bottom = dialogue.top / scale;
    final centerY = top + (bottom - top) * 0.65;
    return _rect((_width - 72) / 2, centerY - 64, 72, 128);
  }

  Rect _rect(double x, double y, double width, double height) =>
      Rect.fromLTWH(x * scale, y * scale, width * scale, height * scale);
}

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../app/presentation/game_chrome_layout.dart';
import '../../../app/presentation/game_spacing.dart';

/// Reference artwork dimensions, projected using one orientation-invariant scale.
/// Rotating a device changes anchors and empty scene space, never frame sizes.
class HomeLayout extends GameChromeLayout {
  HomeLayout(super.viewport, {super.deviceShortSide});

  double get _width => viewport.width / scale;
  double get _height => viewport.height / scale;
  bool get _roomBesideFooter => _width >= 1790;

  static const _edge = GameSpacing.edge;
  static const _gap = GameSpacing.gap;

  Rect get mail {
    final edge = _edge * scale;
    return Rect.fromLTWH(viewport.width - edge - 48, edge, 48, 48);
  }

  // Half-grid gaps keep the centered footer clear of side panels on short
  // landscape windows, without changing any component's size on rotation.
  bool get _tight => !_roomBesideFooter && _height < 1200;
  double get _footerGap => _tight ? GameSpacing.small : _gap;

  Rect get actions => _rect(
    (_width - 840) / 2,
    navigation.top / scale - _footerGap - actionHeight / scale,
    840,
    actionHeight / scale,
  );
  double get actionHeight => math.max(48, 120 * scale);

  double get _dialogueWidth => scale < 390 / 940 ? 700 : 860;

  double get _dialogueHeight => scale < 390 / 940 ? 132 : 120;

  Rect get dialogue => _rect(
    (_width - _dialogueWidth) / 2,
    actions.top / scale - _footerGap - _dialogueHeight / scale,
    _dialogueWidth,
    _dialogueHeight / scale,
  );

  Rect get character {
    final top = _edge;
    final bottom = dialogue.top / scale;
    final centerY = math.min((top + bottom) / 2, bottom - 64 - _gap / 2);
    return _rect((_width - 72) / 2, centerY - 64, 72, 128);
  }

  Rect _rect(double x, double y, double width, double height) =>
      Rect.fromLTWH(x * scale, y * scale, width * scale, height * scale);
}

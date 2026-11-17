import 'package:flutter/material.dart';

/// One bundled font and type scale for Home, menus and dialogs, offline too.
abstract final class GameTypography {
  static const family = 'GameRoboto';
  static const body = TextStyle(fontSize: 17, height: 1.35);
  static const title = TextStyle(
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.bold,
  );
  static const heading = TextStyle(fontWeight: FontWeight.bold);
  static const value = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const label = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
  static const panelTitle = TextStyle(
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );
  static const caption = TextStyle(fontSize: 14, height: 1.35);
}

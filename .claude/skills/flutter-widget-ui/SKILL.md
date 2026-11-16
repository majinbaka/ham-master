---
name: flutter-widget-ui
description: Build Flutter screens, menus, HUD widgets and optional catalogue stories in PixelRPG.
---

# Flutter presentation

Follow the nearest widget. App theme lives in `lib/app/theme/app_theme.dart`;
compose with ThemeData and ColorScheme rather than scattering styling.
Widgets render state and dispatch input. Keep RPG rules outside widgets.
Prefer const StatelessWidget/ConsumerWidget; use stateful lifecycle only for
controllers, focus or animations and dispose resources. Use `ref.watch` while
building and `ref.read` in callbacks. Keep files cohesive and below 400 lines.
Check `flutter-game-a11y` for controls and `flutter-l10n` for strings. Use
`FilterQuality.none` when displaying pixel textures. Do not implement gameplay
or install a catalogue just because a menu is requested. A future story must
import production widgets and configure state rather than duplicate behavior.

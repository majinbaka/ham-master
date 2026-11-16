# Game assets

- `sprites/`: characters, enemies, effects.
- `tilesets/`: terrain and environment tiles.
- `maps/`: authored map data.
- `audio/`: music and sound effects.
- `fonts/`: licensed fonts.

- `branding/ndas-logo.png`: transparent NDAS symbol and wordmark, 840 × 592.
  Derived from the user-supplied `NDAS Neon Loading Screen.png` using built-in
  ImageGen background extraction; no external art or font was imported.
  Prompt: extract the orange N, cyan orbit and white NDAS wordmark unchanged;
  remove black background, PRESENTS, rules, loading bar and loading text;
  preserve colors and glow, use real transparency and a small clear margin.
  The symbol alone is resized onto black for Android launcher and web/PWA icons.
  Flutter renders PRESENTS, loading text and the animated progress separately.

Other folders are empty. Register actual files/directories in `pubspec.yaml` when
adding assets. Keep source dimensions and use `FilterQuality.none` for pixel
textures; choose the logical resolution and tile size with the first game slice.

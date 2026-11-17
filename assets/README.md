# Game assets

- `ui/frame-atlas.png`: six nine-slice UI frame skins, 1536 × 1024 RGBA.
  Built-in ImageGen artwork; measured regions, slice caps and generation prompt
  are documented in [`ui/README.md`](ui/README.md). Text remains a Flutter widget; icons use the separate atlas below.
- `ui/icon-atlas.png`: 18 transparent pixel RPG UI icons, 1536 × 1024 RGBA.
  Generated with built-in ImageGen; regions, order and prompt are documented
  in [`ui/README.md`](ui/README.md). Render with `FilterQuality.none`.
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

The sprites, tilesets, maps, audio and fonts folders are empty. Register actual
files/directories in `pubspec.yaml` when adding assets. Keep source dimensions and use `FilterQuality.none` for pixel
textures; choose the logical resolution and tile size with the first game slice.

- `scenes/twilight-village.png`: 1024 × 1536 static background generated with
  built-in ImageGen for the cozy RPG UI refresh. No baked text or interactive
  map data. Render with nearest-neighbor filtering and `BoxFit.cover`. Menus
  use a dark plum overlay so the illustration does not compete with text.
  Prompt: cute twilight woodland village, plum-roof cream cottages, golden
  lanterns, cyan stream, lavender clearing, chunky crisp pixels; existing
  plum/cream/gold/cyan palette; no characters, text, UI or logos.

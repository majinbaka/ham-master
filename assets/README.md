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
  map data. Archived as the source for the daylight edit.
  Prompt: cute twilight woodland village, plum-roof cream cottages, golden
  lanterns, cyan stream, lavender clearing, chunky crisp pixels; existing
  plum/cream/gold/cyan palette; no characters, text, UI or logos.

- `scenes/daylight-village.png`: 1024 × 1536 static runtime background.
  Built-in ImageGen edit of the twilight scene, using the following prompt.
  Home renders it with nearest-neighbor filtering and `BoxFit.cover`.
  Menus use a light cream overlay with opaque text panels.

  > Edit target is the supplied vertical pixel-art RPG village. Change the
  > lighting from twilight to gentle, cheerful late-morning daylight, keeping
  > the whole portrait composition and large quiet central clearing, tiled
  > cottages, distant arch, stepping stones, pond and waterfall, and crisp
  > chunky pixel-art style in place. Colorful child-friendly storybook palette
  > with clear blue sky, leafy spring green trees with sage shadows, soft grassy
  > green clearing, warm cream cottage walls, one muted terracotta roof and one
  > soft teal roof, turquoise stream, and small butter-yellow, coral-peach and
  > sky-blue flowers. Keep highlights soft and the very large surfaces
  > comfortable to look at. Use medium saturation and softly contrasted color
  > ramps, without neon, heavy dark vignette or purple color cast. Preserve
  > distinct readable forms at a phone scale. No text, lettering, characters,
  > logos, UI, or framing. Portrait 2:3.

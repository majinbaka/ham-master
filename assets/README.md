# Game assets

- `ui/frame-atlas.png`: six nine-slice UI frame skins, 1536 × 1024 RGBA.
  Built-in ImageGen artwork; measured regions, slice caps and generation prompt
  are documented in [`ui/README.md`](ui/README.md). Text remains a Flutter widget; icons use the separate atlas below.
- `ui/icon-atlas.png`: 18 transparent pixel RPG UI icons, 1536 × 1024 RGBA.
  Generated with built-in ImageGen; regions, order and prompt are documented
  in [`ui/README.md`](ui/README.md). Render with `FilterQuality.none`.
- `sprites/`: transparent beast portraits, battle poses and move icons.
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

The tilesets, maps and audio folders are empty. Register actual
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


## Beast and battle preview art

Generated with built-in ImageGen from the two screen references. All text,
buttons and frames are rendered by Flutter.

- `sprites/`: 14 creature sprites and four move icons, each a 128 × 128 RGBA
  PNG. The original transparent atlases were cropped into square cells, trimmed,
  resized with nearest-neighbor sampling and centered on transparent padding.
  Each PNG is one static frame.
- `scenes/forest-arena.png`: 768 × 512 RGB, resized from the generated 3:2
  landscape with nearest-neighbor sampling. Battle places both sprites and
  the targeting cue over this scene as separate widgets.

Generation prompts used these specifications:

- Creatures · Create a square transparent 4 × 4 atlas of isolated, chunky
  32-bit cozy RPG sprites with each sprite centered in its cell: red-orange
  fire fox, icy fox, leafy hare, tan owl, purple bat, boulder golem, blue slime,
  spotted mushroom, electric hare, white rabbit, red boar, blue bird, violet
  wolf with a red mane and a front-facing crouch, and a rear-facing pose of
  the fire fox. Leave the final two cells empty. No shadows, frames or text.
- Moves · Create a transparent 2 × 2 atlas of a gold/orange flaming comet, an
  icy-blue curling gust, three red claw slashes and a sky-blue feathered wing.
  Use the same chunky RPG pixel art, with no background, frames or text.
- Arena · Create a daylight woodland clearing from an elevated camera, with an
  open grass-and-earth center, trees and wildflowers, gray boulders and a
  turquoise brook with a waterfall on the right. Use crisp pixel art and a
  wide 3:2 composition containing only the terrain.

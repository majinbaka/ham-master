---
name: pixel-rpg-art
description: Create or integrate pixel RPG sprites, tilesets, icons and game artwork.
---

# Pixel RPG art

Read the asset brief and [asset inventory](../../../assets/README.md) from the
repository root. For world spritesheets, terrain, props and backgrounds, follow
the [world pixel grid standard](../../../docs/art/world-pixel-grid.md). Use the
128 px standing character and ground anchor to establish the reference sheet
before generation. Keep the source pixel size consistent across all world
assets, and preserve each subject's frame size and anchor through animation.
Validate the exported frames and a composite of sprite and scene at 1×. Redraw
art that misses the reference proportions or grid before integrating it.

For UI artwork, use the [runtime UI guidelines](../../../docs/art/ui-guidelines.md).
Keep UI text outside generated artwork. Inspect the exported pixels, preserve
transparency, check licenses for imported fonts and art, and register real
assets in `pubspec.yaml`.

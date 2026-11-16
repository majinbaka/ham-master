---
name: pixel-rpg-art
description: Create or integrate pixel RPG sprites, tilesets, icons and game artwork.
---

# Pixel RPG art

Read the current asset brief and `assets/README.md`. No palette, character,
tile size or resolution is approved yet; obtain those from the task rather than
inheriting FlashKids art direction. Keep spritesheets on a consistent pixel
grid, use nearest-neighbor rendering (`FilterQuality.none`), preserve requested
transparency, and document frame dimensions/order for animation assets. Keep UI
text outside generated artwork. Inspect actual output and check licenses for
imported fonts and art. Register real assets in `pubspec.yaml`; do not add a
placeholder dependency or a full asset pipeline for a one-off image.

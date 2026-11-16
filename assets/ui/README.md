# UI frame atlas

`frame-atlas.png` is the production atlas consumed by `PixelFrameArtwork`.
Generated with built-in ImageGen for this project; no external art/font pack.
Style follows the user-supplied reference and `docs/art/reusable-ui-concept.md`.
No text, icons, portraits or game content are baked into the sprites.

## Measured geometry

Canvas: **1536 × 1024 RGBA**. Use the measured bounds below, not an assumed
512 × 512 grid: generated placement differs slightly from the prompt.
Every source rectangle is **448 × 440 px**, with **56 px** caps on all sides.
Coordinates are top-left origins in the full atlas.

| Skin | x | y | Use |
| --- | ---: | ---: | --- |
| cream | 48 | 40 | Map, action buttons, speaker tab |
| cool | 544 | 40 | Profile, counters, utilities, navigation tray |
| gold | 1040 | 40 | Main quest body and title |
| cyan | 48 | 540 | Secondary quest body and title |
| paper | 544 | 540 | Dialogue body |
| selected | 1040 | 540 | Selected navigation entry |

Within each rectangle, slice x at `0, 56, 392, 448` and y at
`0, 56, 384, 440`. This yields four corners, four edges and one center.
Render caps at **14 design units** (1/4 source size); stretch only the long
axis of edges and both axes of the center. For slots smaller than 28 units,
reduce both caps equally to avoid overlap. HomeLayout applies its shared
device scale afterward. `FilterQuality.none` preserves pixel steps.

Keep the atlas alpha untouched, including lightly translucent edge pixels.
Flutter caches the image; widgets share it and release their image handles.
Pixel tests compare all four corners at two sizes for all six skins and
check that the top edge has no transparent seams. The original generated
atlas is used directly, without recoloring or resampling it on disk.

## Generation prompt

The following is the actual prompt used; dimensions above record the result.

```text
Use case: stylized-concept. Asset type: production pixel RPG UI sprite atlas, transparent PNG. Create ONE tightly organized sheet of SIX blank square nine-slice frame sprites, 3 columns by 2 rows, equally spaced on a transparent canvas. All six have identical bounding geometry and border thickness. Each frame is a square with subtly rounded stepped pixel corners, layered thin dark outline, luminous narrow bevel rim, short bottom bevel, quiet perfectly flat interior suitable for text. Reference style: cozy polished pixel RPG interface, dark plum panels, warm cream highlights, crisp pixel steps. NO text, letters, numbers, icons, characters, scenery, checkerboard, guide lines, dividers, grain, watermarks, decorative flourishes or shine across the center. Top row left: dark plum #302B46 face with cream #F4D9A3 rim. Top row center: dark plum face with cool lavender blue #9CAED9 rim. Top row right: dark plum face with warm gold #FFD15A rim. Bottom row left: dark plum face with muted cyan #65DDEB rim. Bottom row center: pale paper #FFF2E5 face with dark plum outline and subtle lavender rim. Bottom row right: warm gold face with bright cream-gold rim. Each frame has simple repeatable straight edges, perfectly uniform center color, all detail contained within the corners and narrow border. Pixel art logical grid, no smooth vector curves. Canvas 1536x1024, cells 512x512, frame bounds inset 48 pixels from every cell edge (416x416 each), corners fitting within 48 pixels of frame bounds. Transparent outside each silhouette; opaque filled interiors. Render a clean usable sprite atlas, not a mockup.
```

# UI frame atlas

The home UI also uses the independent `icon-atlas.png` described below.

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

## Pixel icon atlas

`icon-atlas.png`: **1536 × 1024 RGBA**, generated with built-in ImageGen.
Original alpha is preserved; no external art or fonts were imported. It replaces
all 18 Material icons in the home HUD, quests, map, utilities, actions and navigation.
Text, semantics, selected plates and unavailable states remain separate widgets.

`PixelIconKind` records six columns (x = column × 256) and three measured
row origins **64, 388, 720**. Each source region is **256 × 256 px**; the
original transparent gutters are retained, and the image is never stretched
out of square or tinted. `PixelIcon` shares Flutter's image cache and renders
with `FilterQuality.none`. The artwork uses a consistent coarse pixel treatment;
the generated output is not a claim of an exact logical 16 × 16 sprite grid.

| Row | Left to right |
| --- | --- |
| 1 | Coin, gem, energy, home, compass, beasts |
| 2 | Battle, backpack, story, main quest, side quest bookmark, lock |
| 3 | Mail, tasks, information, talk, observe, search |

### Icon generation prompt

```text
Use case: stylized-concept. Asset type: ONE production pixel RPG UI icon sprite atlas, transparent PNG, landscape 1536x1024. Create exactly 18 isolated icons in a strict evenly spaced 6-column by 3-row grid. Each cell is 256 pixels wide and one third of canvas height. Place each icon centered within its cell, all icons about 160x160 pixels, with generous completely transparent gutters; no icon crosses cell boundaries. Row 1 left to right: gold coin with embossed small diamond; cyan faceted gemstone; golden lightning bolt; cozy small cottage with cream walls and plum roof (home); brass compass with cyan needle (explore); cute lavender paw print (beasts). Row 2 left to right: steel shield with gold rim (battle); brown leather adventurer backpack (inventory); open cream storybook with plum binding (story); rolled parchment quest scroll with gold seal (main quest); cyan ribbon bookmark (side quest); silver padlock with brass shackle (locked map). Row 3 left to right: cream envelope with red wax seal (mail); parchment checklist with three cyan checkmarks and horizontal marks but no letters (tasks); round lavender medallion bearing a simple cream lowercase i symbol (information); cream speech bubble containing three plum square dots (talk); brass magnifying glass with cyan lens (observe); folded cream map with cyan route and small brass magnifier (search). Style: polished warm friendly 16-bit fantasy pixel RPG inventory sprites, consistent coarse square pixel grid, crisp stepped silhouettes, dark plum #211B32 outlines 2 logical pixels, upper-left cream highlights, short lower-right shadows, limited flat color clusters. Palette dark plum #302B46, lavender #9CAED9, cream #F4D9A3, gold #FFD15A, cyan #65DDEB, parchment #FFF2E5, muted leather brown. Readable when displayed at 16-24px. Front-facing symbolic objects, no isometric bases. Transparent background with real alpha outside icons. No tile backgrounds, no frames, no panels, no labels, no numbers, no captions, no watermark, no gradients, no glow, no blur, no checkerboard. All 18 complete silhouettes visible and separate, equal visual weight.
```

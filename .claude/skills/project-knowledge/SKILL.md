---
name: project-knowledge
description: Answer questions about the current PixelRPG foundation, architecture and what exists.
---

# Project knowledge

Read `README.md`, `AGENTS.md`, `pubspec.yaml` and
`docs/adr/0001-flutter-foundation.md` and
`docs/adr/0003-offline-game-core.md`, then inspect the relevant source.
The app contains a three-second dark NDAS loading screen at `/`, a main screen
at `/home` with shared code frames, a static daylight village, a code-drawn
pixel traveler portrait, dialogue and navigation to sample menus. An unframed
mail icon opens a preview dialog. Scene actions update the Home dialogue panel.
Shop, profile and settings previews live at `/home/shop`, `/home/profile`
and `/home/settings`. Shop filters sample items and shows details. Profile
has collection and badge tabs. Settings opens on Account, with General and Information
as the other tabs. General controls change local widget selections and offer a
confirmation dialog to reset them.
Profile opens `/home/beasts`, an illustrative roster with collection, filters,
sorting, favorites and details. Home and Beasts open
`/home/battle`, a full-screen encounter with fixed HP and manual attack previews.
No purchase, game progress, audio/device configuration or persistence occurs.
The menus reuse `lib/app/presentation/` shell/controls and icon artwork, with
scrolling content above fixed navigation. Read `docs/art/ui-guidelines.md`
for the shared runtime concept. Home is the visual reference for menu framing
and bottom navigation. GameChromeLayout owns the shared navigation anchor. GameSurfaceStyle owns 2 dp
borders and 8 dp corners. Selected menu controls use color and semantics.
Only the middle framed content scrolls; headers and navigation stay fixed.
MenuPanel uses a dark body/floating gold title tab, with paper for reading;
MenuGrid aligns card rows and PixelProgress uses the common border shape.
Shared widgets live in lib/app/presentation/, shared frames and icons in pixel/.
Master/detail columns stack below 600 times text scale.
See `docs/art/menu-layouts.md` for the concept images and atlas composition script.
UI groups keep fixed sizes when rotating. Mail anchors top-right and
dialogue, actions and single-row navigation anchor bottom-center. Only the village
scene expands at normal text scale. Content copy wraps at logical sizes;
large text uses the shared scrolling shell. One device scale accommodates
smaller artwork; desktop does not enlarge it. Riverpod scope, go_router, theme
and platform shells remain in place. NDAS
branding is in `assets/branding/` with Android/web icons. Six frame skins only
change colors; frames are drawn in code with the common surface geometry.
The original frame atlas is archived, not bundled at runtime.
Text/icons remain separate widgets; selected controls use a gold border and check mark.
GameSpacing defines a roughly 4 dp grid at a 390 dp short side, with 8 dp outer
gutters/group gaps and compact footer gaps on short windows. Button content is
centered, with identical content padding for selected/unselected navigation slots.
Static beast and move sprites live in `assets/sprites/`. Tileset, map and audio folders remain empty. Separate implemented behavior from future ideas. There is no gameplay, game engine, save system, backend,
Widgetbook, Patrol or localization. Do not reuse FlashKids product history as
facts about this repository. Cite current files when answering.

The agreed product targets are Android and web with a mobile-first experience;
iOS is scaffold-only and outside the agreed scope. Build real offline gameplay
in a planned pure Dart package at `packages/game_core/`, then extract service
processing to an API later. This package does not exist yet. JSON mock responses
are no longer the agreed approach. Feature ports isolate presentation from local
and future HTTP adapters. Core owns game rules and state transitions; platform
adapters handle local saves when progression is introduced. Offline remains in
scope; online synchronization and conflicts are undecided.

UI dùng chữ nội dung menu 17 dp, tiêu đề menu 18 dp. Nút compact chỉ hiện icon lớn
trong suốt và tên qua tooltip/semantics; thẻ nội dung bật `showLabel` để hiện tên.
Không nền/viền bọc icon; viền kem bo mềm chỉ thuộc nút. Nút không có icon giữ chữ.

Font `GameRoboto` được đóng gói cùng app (regular/medium/bold và giấy phép),
không phụ thuộc font hệ điều hành hoặc mạng. `GameTypography`/`appTheme` sở hữu
kiểu chữ và shape nút chung; Home action dùng `MenuButton` như các menu.

Home dialogue uses MenuPanel at logical sizes: body 17 dp,
panel title 16 dp, matching menus after transforms. Panel titles keep their logical font size.
HomeReadingView reflows Home in the shared scrolling shell above 1.15 text
scale so larger copy is readable with navigation fixed.
Widget tests load bundled GameRoboto and compare rendered font sizes.

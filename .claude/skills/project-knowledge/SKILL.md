---
name: project-knowledge
description: Answer questions about the current PixelRPG foundation, architecture and what exists.
---

# Project knowledge

Read `README.md`, `AGENTS.md`, `pubspec.yaml` and
`docs/adr/0001-flutter-foundation.md` and
`docs/adr/0003-offline-game-core.md`, then inspect the relevant source.
The app contains a three-second neon NDAS loading screen at `/`, a main screen
at `/home` with shared code frames, HUD, empty quests, a static twilight village, a code-drawn
pixel traveler portrait, welcome panel and navigation to sample menus.
The main quest panel opens the read-only `/home/quests` preview, which reuses
shared code frames and the icon atlas for tabs, chapters, sample objectives and rewards.
Story, shop, profile and settings previews live at `/home/story`, `/home/shop`,
`/home/profile` and `/home/settings`. Story opens `/home/story/episode` without
advancing progress; shop filters sample items and shows details; profile switches
collection/badge tabs; settings controls change ephemeral local widget selections.
No purchase, game progress, audio/device configuration or persistence occurs.
The menus reuse `lib/app/presentation/` shell/controls and icon artwork, with
scrolling content above fixed navigation. Read `docs/art/ui-guidelines.md`
for the shared runtime concept. Home is the visual reference: menu HUD uses
PlayerHud/ResourceHud projected at exactly the same scale and anchors;
GameChromeLayout owns shared chrome geometry. GameSurfaceStyle owns 2 dp
borders and 8 dp corners; ArtworkProjection compensates for scaled HUDs.
Only the middle framed content scrolls; headers and navigation stay fixed.
MenuPanel uses a dark body/floating gold title tab, with paper for reading;
MenuGrid aligns card rows and PixelProgress uses the common border shape.
Shared widgets live in lib/app/presentation/, shared frames and icons in pixel/.
Master/detail columns stack below 600 times text scale. Story episodes reuse
the menu shell. HUD counters use the same unavailable placeholders as Home. Four blank 2:3
design images and the atlas composition script are documented in `docs/art/menu-layouts.md`.
An information dialog explains this UI-only scope. UI groups keep fixed sizes
when rotating: profile/stacked quests anchor left, resources/map anchor right,
and dialogue/actions/single-row navigation anchor bottom-center. Only the village
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
Sprite, tileset, map and audio folders remain empty. Separate implemented behavior from future ideas. There is no gameplay, game engine, save system, backend,
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

UI dùng chữ nội dung menu 17 dp, tiêu đề 22 dp. Nút compact chỉ hiện icon lớn
trong suốt và tên qua tooltip/semantics; thẻ nội dung bật `showLabel` để hiện tên.
Không nền/viền bọc icon; viền kem bo mềm chỉ thuộc nút. Nút không có icon giữ chữ.

Font `GameRoboto` được đóng gói cùng app (regular/medium/bold và giấy phép),
không phụ thuộc font hệ điều hành hoặc mạng. `GameTypography`/`appTheme` sở hữu
kiểu chữ và shape nút chung; Home action dùng `MenuButton` như các menu.

Home quest/minimap/dialogue use MenuPanel at logical sizes: body 17 dp,
panel title 16 dp, matching menus after transforms. ScaledArtwork is limited
to shared compact HUD and decorative controls; panel titles never fit down.
HomeReadingView reflows Home in the shared scrolling shell above 1.15 text
scale so larger copy is readable without moving HUD/navigation anchors.
Widget tests load bundled GameRoboto and compare rendered font sizes.

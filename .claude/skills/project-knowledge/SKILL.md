---
name: project-knowledge
description: Answer questions about the current PixelRPG foundation, architecture and what exists.
---

# Project knowledge

Read `README.md`, `AGENTS.md`, `pubspec.yaml` and
`docs/adr/0001-flutter-foundation.md` and
`docs/adr/0003-offline-game-core.md`, then inspect the relevant source.
The app contains a three-second neon NDAS loading screen at `/`, a main screen
at `/home` with nine-slice sprite frames, HUD, empty quests, a black scene, a yellow
character placeholder, welcome panel and navigation to sample menus.
The main quest panel opens the read-only `/home/quests` preview, which reuses
the frame and icon atlases for tabs, chapters, sample objectives and rewards.
Story, shop, profile and settings previews live at `/home/story`, `/home/shop`,
`/home/profile` and `/home/settings`. Story opens `/home/story/episode` without
advancing progress; shop filters sample items and shows details; profile switches
collection/badge tabs; settings controls change ephemeral local widget selections.
No purchase, game progress, audio/device configuration or persistence occurs.
The menus reuse `lib/app/presentation/` shell/controls and atlas assets, with
scrolling content above fixed navigation. Four blank 2:3 design images and the
atlas composition script are documented in `docs/art/menu-layouts.md`.
An information dialog explains this UI-only scope. UI groups keep fixed sizes
when rotating: profile/stacked quests anchor left, resources/map anchor right,
and dialogue/actions/single-row navigation anchor bottom-center. Only the black
scene expands; the home layout does not scroll, wrap or hide the minimap.
One shared device scale accommodates smaller screens; desktop does not enlarge UI. Riverpod scope, go_router, theme
and platform shells remain in place. NDAS
branding is in `assets/branding/` with Android/web icons. Six frame skins share
`assets/ui/frame-atlas.png`; corners keep their shape while edges/centers stretch.
Text/icons remain separate widgets; only the selected navigation item has a plate.
HomeSpacing defines a roughly 4 dp grid at a 390 dp short side, with 8 dp outer
gutters/group gaps and compact footer gaps on short windows. Button content is
centered, with identical content padding for selected/unselected navigation slots.
Other asset folders remain empty. Separate implemented behavior from future ideas. There is no gameplay, game engine, save system, backend,
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

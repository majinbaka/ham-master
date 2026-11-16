---
name: project-knowledge
description: Answer questions about the current PixelRPG foundation, architecture and what exists.
---

# Project knowledge

Read `README.md`, `AGENTS.md`, `pubspec.yaml` and
`docs/adr/0001-flutter-foundation.md` and
`docs/adr/0003-offline-game-core.md`, then inspect the relevant source.
The app contains a three-second neon NDAS loading screen at `/`, a main screen
shell at `/home`, Riverpod scope, go_router, theme and platform shells. NDAS
branding is in `assets/branding/` with Android/web icons; other asset folders
remain empty. Separate implemented behavior
from future ideas. There is no gameplay, game engine, save system, backend,
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

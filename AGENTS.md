# PixelRPG agent guidance

Single-package Flutter foundation for a mobile pixel RPG, derived from the
structure and development skills of FlashKids. The three-second dark NDAS
loading screen leads to a pixel-styled Home with a static daylight village
and a code-drawn traveler portrait. The unframed mail icon opens a dialog,
and the battle action opens the full-screen battle preview. Scene actions
update the dialogue panel.
Shop, profile, settings, beasts and battle are presentation-only previews.
Do not implement gameplay unless requested.

## Agreed product scope and offline package boundary

- Android and web are supported product targets. Design mobile-first with touch
  controls and layouts usable on phone-sized screens. Web supports complete
  implemented game flows. iOS remains scaffold-only and outside the agreed scope.
- Build a genuinely playable offline game before extracting a separate API.
  Implement real game operations and state transitions in a pure Dart package
  at `packages/game_core/`, not hard-coded JSON responses or a mock API.
  This is a planned package; create it when the first requested flow needs it.
- `game_core` owns authoritative game models, rules, use cases, validation and
  state transitions. It must not depend on Flutter, Riverpod, rendering engines,
  transport, platform-only I/O or app internals. Client features own presentation
  and orchestration, not duplicate implementations of core game rules.
- Expose an explicit asynchronous service boundary with immutable commands,
  results and errors that can be serialized later. Keep core internals private;
  never share mutable game state with UI or controllers. Do not add HTTP or a
  separate contracts package before concrete integration needs it.
- Feature application code depends on client-facing ports. Infrastructure
  adapters call `game_core`; `lib/app/` injects them. Widgets and controllers
  must not call core implementations directly. Later an HTTP adapter can replace
  the local adapter behind the same ports.
- The core defines storage ports as needed; platform adapters implement local
  saves for Android and web. Offline progress must survive app restart when
  progression is introduced. Keep storage technology and serialization details
  outside core rules. JSON may encode content or saves, but is not a substitute
  for actual game behavior. No storage system is implemented yet.
- Make tests controllable through injected clock, randomness and storage when
  needed. Test real state transitions, validation, failures and save/restore
  with deterministic inputs. Verify implemented flows offline on Android and
  web. Test fixtures and reset/seed helpers must not become production cheats.
- Future extraction moves authoritative processing behind an API; reuse the
  Dart core if the backend supports it, otherwise preserve behavior with the
  same scenarios and contracts. Keep offline support as the agreed game mode;
  online sync, conflict resolution and anti-cheat are separate future decisions.
  Backend language, hosting, authentication and endpoints remain undecided.
- This scope update defines ownership only. Do not implement speculative
  gameplay, persistence, endpoints or empty packages.

## Repository map

- `lib/main.dart`: bootstrap and `ProviderScope`.
- `lib/app/`: app composition, router and theme.
- `lib/features/launch/presentation/`: three-second NDAS loading screen.
- `lib/features/home/presentation/`: home scene with anchored artwork, shared
  logical-size dialogue panel, interactive utilities and large-text reflow.
- `lib/app/presentation/pixel/`: shared code frames, atlas icons and progress tracks.
- `lib/features/{shop,profile,settings}/presentation/`: interactive menu previews.
- `lib/features/beasts/presentation/`: sample roster, collection, filters and details.
- `lib/features/battle/presentation/`: full-screen arena, sample HP, and manual attack previews.
- `lib/app/presentation/`: shared Home/menu chrome anchors, artwork projection,
  spacing, navigation, menu shell, panels, buttons, grids and progress.
- `assets/`: NDAS branding and `ui/` icon atlas plus archived frame artwork;
  village and forest arena in `scenes/`; static beast and move sprites in
  `sprites/`; empty tileset, map and audio folders; bundled Roboto fonts and license in `assets/fonts/`.
- `test/`: Flutter tests; mirror feature paths as behavior is introduced.
- `android/`, `web/`: platform scaffolds with NDAS launcher/web icons.
- `ios/`: unchanged platform scaffold.
- `packages/game_core/`: planned pure Dart offline game package; not created yet.
- `.claude/skills/`: source of project skills adapted from FlashKids.
- `.agents/skills/`: relative symlinks to the same skills for Codex.
- `.claude/commands/`: `/dod` and `/defer`.
- `docs/adr/`: accepted architecture and decision template.
- `deferred-work/`: out-of-scope issues, using the template.

## Working rules

For every UI change, read and follow `docs/art/ui-guidelines.md`, the runtime
UI concept for current and future screens. Reuse the shared menu shell,
responsive columns, navigation, palette and atlas components. Home is the visual
reference: menus must use its artwork density and navigation anchors;
only their middle content scrolls. Reference layout
PNGs describe visual intent, not fixed runtime dimensions. Update this guideline
in the same change when intentionally changing the shared visual rules.

Read scoped instructions and relevant docs before editing. State the intended
behavior and owning module. Make the smallest change that satisfies the task.
Preserve unrelated files and user work. Update documentation made false by the
change. Report genuine conflicts that cannot be resolved from user instructions.
Do not treat copied FlashKids product policy as a requirement of this game.

Use feature-first slices: `lib/features/<feature>/` with `presentation/`,
`application/`, `domain/`, `infrastructure/` only when needed. Composition and
routing belong to `lib/app/`. Presentation depends on application/domain ports;
adapters implement ports. Domain/application must not import Flutter widgets,
GoRouter, storage, network or game-engine implementations. Pure Riverpod may be
used for controllers; Flutter provider wiring belongs at composition boundaries.
Production must not import tests or future catalogues.

Riverpod owns state/DI; go_router owns app navigation. There is no game engine,
save system, backend, localization, code generation, Widgetbook or Patrol yet.
Introduce those only for concrete requested behavior. Keep game rules separate
from rendering. Do not invent generic repositories, managers or utility layers.
Keep each file cohesive and below 400 lines.

Never hand-edit generated Dart files, suppress tooling just to pass checks, or
commit secrets. Use meaningful behavior tests for gameplay, saves and failures;
keep bootstrap verification small. Do not add dependencies speculatively.
Commit or publish only when requested.

## Definition of done

```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Run code generation first only after introducing annotated sources and their
tooling. Review status/diff for unrelated changes and secrets. Report checks
that could not run, including platform build limitations.

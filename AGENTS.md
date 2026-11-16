# PixelRPG agent guidance

Single-package Flutter foundation for a mobile pixel RPG, derived from the
structure and development skills of FlashKids. The only runtime behavior is a
launch screen. Do not implement gameplay unless requested.

## Repository map

- `lib/main.dart`: bootstrap and `ProviderScope`.
- `lib/app/`: app composition, router and theme.
- `lib/features/launch/presentation/`: placeholder launch screen.
- `assets/`: empty sprite, tileset, map, audio and font folders.
- `test/`: Flutter tests; mirror feature paths as behavior is introduced.
- `android/`, `ios/`, `web/`: fresh Flutter platform scaffolds.
- `.claude/skills/`: source of project skills adapted from FlashKids.
- `.agents/skills/`: relative symlinks to the same skills for Codex.
- `.claude/commands/`: `/dod` and `/defer`.
- `docs/adr/`: accepted architecture and decision template.
- `deferred-work/`: out-of-scope issues, using the template.

## Working rules

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

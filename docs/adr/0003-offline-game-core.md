# ADR-0003: Offline game core

Status: accepted; supersedes ADR-0002.

## Context

The user chose real offline gameplay over hard-coded JSON API simulation to
exercise actual game behavior with controllable test inputs before extracting
a separate API. Android and web remain the mobile-first product targets.

## Decision

Introduce `packages/game_core/` as a pure Dart package when the first requested
game flow needs it. It owns authoritative game models, rules, use cases,
validation and state transitions. It does not depend on Flutter, Riverpod,
rendering engines, transport, platform-only I/O or app internals.

Expose asynchronous operations using immutable commands, results and errors
that can be serialized later. Keep internal mutable state private. App feature
ports and local infrastructure adapters isolate widgets/controllers from core
implementations; `lib/app/` composes dependencies. Do not duplicate core rules
in the client or introduce speculative HTTP endpoints or contracts packages.

When progression is introduced, persist it locally on both Android and web
across app restarts. Core defines storage ports as needed; external platform
adapters implement them. JSON may encode content or saves, but does not replace
executing real game behavior. Storage technology remains undecided.

Inject clock, randomness and storage where needed for deterministic tests of
rules, state transitions, validation, failures and save/restore. Verify actual
offline flows on Android and web. Keep test seed/reset helpers out of normal
production play.

Later move authoritative processing behind an API and replace the local adapter
with HTTP behind the same feature ports. Reuse the core on a Dart backend when
appropriate; otherwise preserve behavior through shared scenarios and contracts.
Offline remains an agreed mode. Online synchronization, conflict handling,
anti-cheat, backend language, hosting, authentication and endpoints are future
decisions, not implicit requirements of this change.

## Consequences

The current implementation remains a single Flutter package with a launch
screen. This decision defines future ownership; it adds no gameplay, package
or persistence implementation. Create these only for requested behavior.

Tests exercise real logic rather than canned responses. Future API extraction
still requires transport, deployment and any server security/storage work, but
the client already calls an isolated service boundary.

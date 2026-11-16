# ADR-0002: Platform scope and API boundary

Status: superseded by [ADR-0003](0003-offline-game-core.md).

The JSON mock approach below is historical. Use a real offline game package
instead; Android/web scope remains unchanged.

## Context

The game needs complete client flows on Android and web before a separate API
service exists. Local simulation must allow that service to be extracted later
without coupling widgets and controllers to simulated data or service rules.
This supersedes ADR-0001's platform scope and open backend direction.

## Decision

Support Android and web as product targets with a mobile-first experience.
Keep the existing iOS scaffold, but exclude iOS from the agreed product scope.

Introduce pure Dart modules when the first API-backed flow is implemented:
`packages/api_contracts/` for JSON-compatible request/response DTOs,
serialization and errors, and `packages/mock_api/` for JSON fixtures and
simulated service behavior. Neither module depends on Flutter, platform-only
I/O or app internals. Supply any platform-specific fixture loader at app
composition. The simulation runs locally in Android and web builds.

Feature application/domain layers own client ports and models. Infrastructure
adapters translate API DTOs to feature models; `lib/app/` injects adapters.
Widgets and controllers do not import the mock module or read its fixtures.
Service rules belong to the mock module; presentation rules belong to the app.
Requests and responses do not share mutable state or app domain instances.

Later, extract service behavior to a backend and replace the local adapter with
an HTTP adapter implementing the same client ports. Preserve the JSON contract
and verify compatibility; a backend in another language need not reuse Dart
source. Backend technology, hosting, authentication and endpoints remain open.

## Consequences

The repository currently remains a single Flutter package with a launch screen.
This decision defines future module ownership, not implemented API behavior.
Create modules and dependencies only as required by requested flows. JSON
fixtures do not imply player-save persistence.

Test contracts and mock scenarios independently with pure Dart tests, including
relevant failures. Verify each implemented client flow on both Android and web.
Future extraction still requires server deployment, transport and any required
security or persistence work; this boundary limits changes in the client.

---
name: flutter-data-model
description: Create immutable game models, DTOs and serialization contracts in PixelRPG.
---

# Game models

Use small immutable Dart types with const constructors by default. No Freezed,
JSON generator or build_runner is installed. Add generation only when a real
model or serialization boundary benefits from it; run the generator after
annotated source changes and never hand-edit generated files. Keep domain
models independent of Flutter, engine and storage SDKs. Keep storage DTOs at
adapter boundaries. Nullable fields mean genuine absence, not loading state.
Before changing saved shapes, identify released data and consumers, define
versioned migration, and test compatibility. No save format exists yet.

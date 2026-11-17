---
id: 2026-11-17-assets-font-inventory
title: Asset inventory incorrectly lists the bundled font folder as empty
severity: low
status: open
found_during: Reviewing artwork for the cozy RPG UI refresh
date: 2026-11-17
---

## Summary

The asset inventory still says the fonts folder is empty, although the app
already bundles and registers Roboto. This statement predates the UI refresh.

## Where

- `assets/README.md:24` — includes fonts among the empty folders.
- `pubspec.yaml:27` — registers GameRoboto and the bundled font files below it.
- `assets/fonts/Roboto-Regular.ttf` — actual font file, alongside Medium/Bold.

## Expected vs. actual

**Expected:** Inventory distinguishes bundled fonts from empty game asset folders.

**Actual:** One paragraph incorrectly describes all five folders as empty.

## Reproduction / evidence

Observed by reading `assets/README.md`, `pubspec.yaml`, and listing
`assets/fonts/`; no runtime font defect was observed. Bundled-font tests pass.

## Suggested fix

Correct the inventory paragraph in `assets/README.md`. Documentation only;
no routes, contracts, dependencies or runtime files need to change.

## Not done because

This pre-existing inventory mismatch is outside the UI redesign; recorded
separately under the log-issue and sync-docs workflow.

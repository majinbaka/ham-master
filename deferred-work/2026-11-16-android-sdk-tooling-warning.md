---
id: 2026-11-16-android-sdk-tooling-warning
title: Android build reports incompatible SDK metadata reader versions
severity: low
status: open
found_during: NDAS branding and three-second loading screen
date: 2026-11-16
---

## Summary

The Android debug build succeeds but the installed SDK tooling reports a
metadata reader version mismatch. The exact responsible tool was not isolated.

## Where

- `android/settings.gradle.kts:22` — Android build plugin entry point; this
  reference does not establish that its version caused the warning.
- Local Android SDK installation — environment-specific metadata and tools.

## Expected vs. actual

**Expected:** Android SDK metadata is read without compatibility warnings.

**Actual:** `flutter build apk --debug` reports that the reader understands SDK
XML through version 3 while a version 4 file was encountered. The APK still builds.

## Reproduction / evidence

Observed during `flutter build apk --debug` on 2026-11-16:

> This version only understands SDK XML versions up to 3 but an SDK XML file of version 4 was encountered.

No Android device or emulator was connected for runtime verification.

## Suggested fix

Inspect the installed Android command-line tools and Android Studio versions,
then align the SDK tools as needed. Rebuild before considering repository plugin
changes; avoid changing Gradle dependencies without identifying the source.

## Not done because

Local SDK maintenance is outside the requested branding and loading-screen work.

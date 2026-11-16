---
id: 2026-11-16-web-cupertino-font-warning
title: Web build reports a missing CupertinoIcons font family
severity: low
status: open
found_during: Implementing the pixel home interface
date: 2026-11-16
---

## Summary

The web release build succeeds but reports that the CupertinoIcons font family
is expected and unavailable. No missing runtime icon has been confirmed.

## Where

- `pubspec.yaml:9` — dependencies do not include `cupertino_icons`.
- `pubspec.yaml:20` — Flutter assets enable Material icons only.

## Expected vs. actual

**Expected:** Every icon font referenced by the compiled application is bundled,
or unused references do not produce a missing-font warning.

**Actual:** Flutter 3.47.2 reports an expected
`packages/cupertino_icons/CupertinoIcons` family while finding only
`MaterialIcons`. The new home widgets use Material `Icons`, not CupertinoIcons.

## Reproduction / evidence

Run `flutter build web --no-web-resources-cdn`.
The output includes:

```text
Expected to find fonts for (MaterialIcons, packages/cupertino_icons/CupertinoIcons), but found (MaterialIcons).
```

The build completes successfully. Browser runtime verification was unavailable
because no browser is connected. The originating transitive reference has not
been traced; this records the observed warning, not a confirmed rendering bug.

## Suggested fix

Trace the retained Cupertino icon reference in the Flutter/framework dependency
chain. Remove it if unnecessary, or declare the required font package if used.
Potential scope is `pubspec.yaml`, lockfile and icon asset output; no game
contracts or routes should change. Verify the resulting web build and icons.

## Not done because

Dependency/font cleanup is outside the requested home-screen implementation;
no dependency was added solely to silence a build warning.

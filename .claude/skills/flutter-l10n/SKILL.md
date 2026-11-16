---
name: flutter-l10n
description: Add or change player-facing copy and introduce Flutter localization when requested.
---

# Player-facing strings

The foundation only displays the brand `Pixel RPG`. There is no locale policy,
ARB setup or generated localization yet. Do not add localization as an unrelated
side effect. Once requested, choose source/supported locales with the task,
configure Flutter ARB generation, and share delegates across runtimes. Use
meaning-based lowerCamelCase keys with descriptions, ICU placeholders/plurals,
and locale-sensitive formatting. Update all locale files when keys change.
Keep item/save identifiers separate from translated labels. Test wrapping,
text scaling and actual translated output for relevant UI behavior.

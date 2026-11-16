---
name: widgetbook-catalogue
description: Introduce or maintain a Widgetbook catalogue when the PixelRPG task requests one.
---

# Optional Widgetbook catalogue

Widgetbook is not installed and no catalogue exists. Introduce it only when
requested. Place stories under `widgetbook/`, outside `lib/`, importing the
same production menus and HUD widgets. Supply state and provider overrides;
never copy a screen or reimplement its logic. Group stories by owning feature
and meaningful scenario. Keep router/theme reuse explicit. Test behavior with
Flutter tests; stories are review aids rather than regression assertions.

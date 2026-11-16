# ADR-0001: Flutter foundation

Status: accepted for the initial scaffold.

Reuse FlashKids' single-package, feature-first organization with Riverpod for
state/dependency injection and go_router for app navigation. App composition
lives in `lib/app/`. Feature presentation depends on application/domain ports;
infrastructure implements those ports. Game rules stay independent of Flutter
widgets and engine implementations. Add layers only when they own real code.

Android and iOS are mobile targets; web is a convenient development target.
The initial implementation contains only a launch route. Engine choice, tile
size, orientation, logical resolution, gameplay, persistence and backend remain
open. No FlashKids product behavior or assets are inherited.

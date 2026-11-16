---
name: flutter-routing
description: Add or change go_router routes, navigation, redirects and typed route parameters in PixelRPG.
---

# App routing

The shared router is `lib/app/router/app_router.dart`, exposed through
`appRouterProvider`; the only initial route is `/` named `launch`. Keep one
router definition. Use lowercase kebab-case paths, named navigation, and typed
parameter validation at the boundary. Keep redirects with routing policy.
Game-world movement belongs to game logic, not go_router. Before renaming a
route, search navigation calls, deep links, docs and tests. Verify navigation
behavior and run the full Flutter test suite for shared routing changes.

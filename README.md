# PixelRPG

Khung Flutter tối thiểu cho game mobile pixel RPG, tham khảo cấu trúc FlashKids.
Tên `PixelRPG` / package `pixel_rpg` là tên khởi tạo, có thể đổi sau.

## Chạy dự án

```sh
flutter pub get
flutter run
# Preview trên trình duyệt:
flutter run -d chrome
```

Yêu cầu Dart >=3.9 và Flutter stable tương thích các dependency trong
`pubspec.lock`. Android cần Android SDK; build iOS cần macOS và Xcode.
Android application ID: `com.jinshu.pixel_rpg`.
iOS bundle ID: `com.jinshu.pixelRpg`.

## Những gì đã có

- Flutter một package; Android, iOS và web scaffolds tạo mới.
- Riverpod cho state/DI, go_router với route `/`, theme tối thiểu.
- Một màn hình chỉ hiển thị tên game; widget test kiểm tra app khởi động.
- Thư mục assets trống: sprites, tilesets, maps, audio, fonts.
- CI format/analyze/test, hướng dẫn agent, skills và Dart format hook.

```text
lib/
  main.dart
  app/
    pixel_rpg_app.dart
    router/app_router.dart
    theme/app_theme.dart
  features/launch/presentation/launch_screen.dart
assets/{sprites,tilesets,maps,audio,fonts}/
test/widget_test.dart
```

Thêm feature dưới `lib/features/<feature>/`; chỉ tạo các lớp presentation,
application, domain, infrastructure khi có code thực tế cần sở hữu.

## Skills kế thừa

17 skills từ FlashKids được chuyển và điều chỉnh cho repo game. Nguồn ở
`.claude/skills/`, `.agents/skills/` là symlink tương đối để Codex dùng cùng bản.
Xem danh sách tại `CLAUDE.md`. Hai skill riêng sản phẩm được đổi thành
`pixel-rpg-art` và `flutter-game-a11y`; `project-knowledge` được viết lại theo
khung mới. Giữ `/dod`, `/defer`; bỏ `/spec-phase` vì kế hoạch đó của FlashKids.

Gameplay, nhân vật, bản đồ, combat, inventory, save, backend, game engine,
Widgetbook, Patrol, codegen và localization chưa được dựng. Bạn có thể bắt đầu
từ đầu, chọn engine, kích thước tile, hướng màn hình và art direction sau.
Không sao chép logic, assets, thông tin ký app hay lịch sử Git của FlashKids.

## Kiểm tra

```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

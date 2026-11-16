# PixelRPG

Khung Flutter tối thiểu cho game mobile pixel RPG, tham khảo cấu trúc FlashKids.
Tên `PixelRPG` / package `pixel_rpg` là tên khởi tạo, có thể đổi sau.

## Scope đã chốt

- Game pixel RPG thiết kế theo trải nghiệm mobile, hỗ trợ **Android và web**.
  Ưu tiên điều khiển cảm ứng và bố cục trên màn hình điện thoại. Web chạy đầy đủ
  các luồng game đã triển khai để chơi và kiểm thử, không chỉ dùng để preview.
- iOS hiện có scaffold nhưng nằm ngoài scope đã chốt.
- Giai đoạn đầu là **game chơi offline thực sự** trên Android và web. Một
  package riêng xử lý luật game, thao tác và thay đổi trạng thái thật để kiểm
  thử chính xác và dễ điều khiển dữ liệu đầu vào.
- Sau này tách phần xử lý thành API độc lập. Hiện chỉ chốt scope và ranh giới;
  chưa triển khai gameplay, package offline hay lưu tiến trình.

## Phân chia package offline để tách API sau này

Cấu trúc dự kiến, tạo khi có luồng gameplay đầu tiên được yêu cầu:

| Vị trí | Trách nhiệm |
| --- | --- |
| `packages/game_core/` | Package Dart thuần: model game, luật game, use case, kiểm tra đầu vào, thay đổi trạng thái và port lưu dữ liệu khi cần. |
| `lib/features/<feature>/application/`, `domain/` | Điều phối phía client, port thao tác game và model phục vụ client khi cần; không nhân đôi luật trong core. |
| `lib/features/<feature>/infrastructure/` | Adapter gọi package offline; sau này có thể thay bằng adapter HTTP. Adapter lưu dữ liệu theo nền tảng khi cần. |
| `lib/app/` | Chọn và inject adapter cùng các phụ thuộc. |

Luồng gọi: giao diện/controller → port của feature → adapter cục bộ →
`game_core`. Package không phụ thuộc Flutter, Riverpod, engine hiển thị,
network, I/O riêng nền tảng hoặc nội bộ app. UI/controller không gọi trực tiếp
implementation của core hoặc sửa state dùng chung. Luật game chỉ có một nơi
xử lý trong core; app phụ trách hiển thị và điều phối.

Ranh giới dịch vụ dùng lời gọi bất đồng bộ, command, kết quả và lỗi bất biến,
được thiết kế để có thể serialize khi tách API. Chưa cần HTTP hoặc một package
hợp đồng riêng. JSON có thể dùng cho nội dung game hay định dạng save khi cần;
logic phải thực thi thao tác và cập nhật trạng thái thật, không trả response
hard-code thay cho game.

Khi có tiến trình người chơi, lưu cục bộ để tiếp tục sau khi đóng/mở app trên
cả Android và web. Core định nghĩa port lưu trữ; adapter ngoài core xử lý công
nghệ lưu theo nền tảng. Hiện chưa chọn hoặc triển khai hệ thống lưu.

Để kiểm thử dễ điều khiển, inject đồng hồ, nguồn ngẫu nhiên và storage khi cần.
Test trực tiếp package bằng đầu vào xác định: luật game, chuyển trạng thái,
validation, lỗi và lưu/khôi phục. Xác minh các luồng đã triển khai khi offline
trên cả Android và web. Seed/reset phục vụ test không trở thành chức năng gian
lận trong bản chơi thật.

Khi tách backend, đưa phần xử lý có thẩm quyền lên dịch vụ và thay adapter cục
bộ bằng HTTP phía sau cùng port; UI/controller vẫn dùng port. Có thể tái sử dụng
core với backend Dart; nếu dùng ngôn ngữ khác, đối chiếu hành vi bằng cùng bộ
kịch bản và hợp đồng. Chế độ offline vẫn thuộc scope. Đồng bộ online/offline,
xử lý xung đột và chống gian lận sẽ được quyết định riêng khi có yêu cầu.
Ngôn ngữ backend, hosting, xác thực và endpoint chưa được chốt.
Xem [ADR-0003](docs/adr/0003-offline-game-core.md).

## Chạy dự án

```sh
flutter pub get
flutter run
# Chạy bản web:
flutter run -d chrome
```

Yêu cầu Dart >=3.9 và Flutter stable tương thích các dependency trong
`pubspec.lock`. Android cần Android SDK và thiết bị hoặc emulator.
Web cần trình duyệt tương thích Flutter web.
Android application ID: `com.jinshu.pixel_rpg`.

## Những gì đã có

- Flutter một package; Android, iOS và web scaffolds tạo mới.
- Riverpod cho state/DI; go_router với `/` (launch) và `/home` (màn hình chính).
- Loading nền đen với logo NDAS, thanh neon cam tăng từ 0 đến 100% trong
  khoảng 3 giây rồi thay route bằng màn hình chính có logo và tên Pixel RPG.
  Cụm logo và loading cùng trục giữa, nằm gọn trong ô giữa của lưới 3×3
  vùng màn hình an toàn, tự thu nhỏ theo kích thước màn hình.
  Đây là hiệu ứng khởi động, chưa có dữ liệu gameplay cần nạp.
- Logo nền trong suốt trong `assets/branding/`, icon Android và favicon/PWA web.
- Widget test kiểm tra khởi động, thời gian loading, chuyển route và bố cục nhỏ.
- Các thư mục sprites, tilesets, maps, audio, fonts vẫn trống.
- CI format/analyze/test, hướng dẫn agent, skills và Dart format hook.

```text
lib/
  main.dart
  app/
    pixel_rpg_app.dart
    router/app_router.dart
    theme/app_theme.dart
  features/launch/presentation/{launch_screen,neon_progress_bar}.dart
  features/home/presentation/home_screen.dart
assets/{branding,sprites,tilesets,maps,audio,fonts}/
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
từ đầu, chọn engine hỗ trợ Android/web, kích thước tile, hướng màn hình và art
direction sau. Scope nền tảng và hướng tách API đã được chốt ở trên.
Không sao chép logic, assets, thông tin ký app hay lịch sử Git của FlashKids.

## Kiểm tra

```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

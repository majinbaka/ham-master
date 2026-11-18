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
- Riverpod cho state/DI; go_router với `/` (launch), `/home` (màn hình chính)
  và `/home/quests` (bản xem trước Nhiệm vụ); các màn mẫu `/home/story`,
  `/home/shop`, `/home/profile`, `/home/settings`, `/home/story/episode`,
  `/home/beasts` và `/home/battle`.
- Loading nền kem chuyển xanh trời, logo NDAS và thanh vàng đào tăng từ 0 đến 100% trong
  khoảng 3 giây rồi thay route bằng màn hình chính phong cách pixel RPG.
  Cụm logo và loading cùng trục giữa, nằm gọn trong ô giữa của lưới 3×3
  vùng màn hình an toàn, tự thu nhỏ theo kích thước màn hình.
  Đây là hiệu ứng khởi động, chưa có dữ liệu gameplay cần nạp.
- Màn hình chính dùng khung sáng chung, viền 2 dp, bo góc 8 dp, HUD hồ sơ/tài nguyên,
  panel nhiệm vụ, lời chào và thanh chức năng. Cảnh làng pixel ban ngày, nhân vật minh họa đội mũ
  vàng. UI dùng kích thước/tỉ lệ thiết kế cố định: hồ sơ và nhiệm vụ neo trái,
  tài nguyên và tiện ích neo phải; hội thoại, ba nút hành động và thanh sáu mục
  một hàng neo giữa phía dưới. Xoay màn hình giữ nguyên kích thước các cụm,
  chỉ thay vị trí neo và mở rộng tranh nền ở cỡ chữ thường. Nội dung chữ
  xuống dòng theo chỗ trống.
  Kích thước chuẩn tương ứng chiều ngắn 390 dp; thiết bị nhỏ hơn dùng một hệ số
  chung theo chiều ngắn của màn hình, độc lập hướng xoay. Desktop không phóng
  lớn artwork. Chữ nhiệm vụ và hội thoại Home dùng `MenuPanel`
  với cùng cỡ nội dung 17 dp/tiêu đề panel 16 dp như menu, không bị thu
  nhỏ theo artwork. Chữ hệ thống lớn hơn 1.15× chuyển Home sang vùng nội
  dung cuộn chung; HUD và navigation vẫn cố định. Thanh điều hướng dùng control chung với menu, cao ít nhất 60 dp
  để giữ vùng chạm trên điện thoại nhỏ. Vùng an toàn được áp dụng khi đặt các
  cụm. Chỉ nhãn HUD compact nằm trong slot cố định;
  hộp thông tin vẫn dùng cỡ chữ hệ thống và cuộn nội dung khi cần.
  Khoảng cách dùng lưới chung `GameSpacing` khoảng 4 dp/bước: lề an toàn và
  khoảng giữa cụm khoảng 8 dp, footer cửa sổ thấp dùng khoảng 4 dp. Nội dung
  nút compact có icon lớn và tên qua tooltip/semantics; thẻ nội dung hiện
  cả icon và tên bằng `showLabel`. Viền bo mềm thuộc nút, icon không có viền riêng. Nội dung menu 17 dp, tiêu đề 22 dp; padding các ô điều hướng đồng nhất. Xem
  [quy ước spacing](docs/art/reusable-ui-concept.md#9-quy-ước-spacing-runtime-mobile).
  Mọi khung/nút/dialog/EXP dùng `GameSurfaceStyle` (viền 2 dp, góc 8 dp).
  `ArtworkProjection` bù scale HUD để giữ cùng độ dày/độ cong trên màn hình.
  Sáu skin chỉ đổi màu; atlas khung cũ giữ làm tư liệu, không đóng gói runtime. Chữ là widget riêng; 18 icon dùng atlas pixel art
  nền trong suốt. Khung dùng nền ngà, kem, bạc hà và xanh trời nhạt với chữ xanh đậm.
  Mục điều hướng đang chọn có nền cam đào, viền nâu san hô và dấu tick.
  Thanh dưới mở Cốt truyện, Nhiệm vụ, Cửa hàng, Hồ sơ và Cài đặt.
  Cụm tiện ích mở Hộp thư, Nhiệm vụ hàng ngày và Thông tin màn hình.
  Nói chuyện, Quan sát và Tìm kiếm cập nhật nội dung ô hội thoại.
  Chỉ số Trang chủ chưa có dùng dấu `—`.
- Chọn **Xem nhiệm vụ** trong khung Nhiệm vụ chính để mở màn hình mẫu.
  Tab tự xuống hàng; chương và chi tiết xếp dọc trên màn hẹp/chữ lớn,
  chia hai cột khi đủ chỗ; nội dung cuộn bên trên
  thanh điều hướng. Nút quay lại và mục Trang chủ đều về màn hình chính.
  Bốn tab gồm Chính truyện, Phụ, Hàng ngày và Thành tựu. Home có lối tắt
  tới tab Phụ và Hàng ngày. Chương khóa mở hộp thoại điều kiện. Mục tiêu và
  phần thưởng hiển thị dữ liệu minh họa cố định.
- Cốt truyện mở hội thoại xem thử; Cửa hàng lọc danh mục và xem chi tiết;
  Hồ sơ đổi tab sưu tầm/huy hiệu; Cài đặt đổi nhóm và thao tác thử slider,
  switch, lựa chọn và xác nhận khôi phục mặc định của bản xem trước.
  Các màn ghi rõ dữ liệu mẫu, không giao dịch, không thay
  tiến trình hoặc lưu cấu hình. HUD dùng lại chính profile/tài nguyên của Home
  và vẫn neo cố định khi cuộn.
  Tiêu đề, quay lại và navigation nằm ngoài cửa sổ nội dung cuộn ở giữa.
  Panel dùng thân tối/tab tiêu đề nổi như Home; giấy kem dành cho nội dung đọc.
  Chương/vật phẩm/chỉ số dùng lưới ô đều, thanh EXP dùng cùng mẫu viền/góc.
- Hồ sơ mở **Danh sách yêu thú**. Có 12 yêu thú mẫu, bộ sưu tầm ghi thêm
  Sói Bóng Đêm, bộ lọc theo hệ/yêu thích, sắp xếp theo cấp và thẻ chi tiết
  có chỉ số, chiêu thức và các thao tác xem thử.
- Từ Yêu thú hoặc Nhiệm vụ chính, chọn **Xem thử trận chiến** để mở cảnh
  Hỏa Hổ đối đầu Sói Bóng Đêm. Có thể chọn chiêu và mục tiêu, bật/tắt
  tự động, đổi tốc độ và tạm dừng trong giao diện mẫu. Thanh HP hiển thị
  giá trị minh họa cố định. Nút quay lại trở về màn đã mở trận.
- Logo nền trong suốt trong `assets/branding/`, icon Android và favicon/PWA web.
- Widget test kiểm tra khởi động, thời gian loading, chuyển route, màn hình
  chính, hộp thông tin, bố cục nhỏ/chữ lớn và kích thước/neo không đổi khi xoay.
  Kiểm tra pixel xác minh viền 2 dp và silhouette góc không đổi khi thay
  skin, kích thước hoặc projection.
- Font Roboto được đóng gói trong `assets/fonts/` với giấy phép; mọi màn dùng
  `GameTypography`/`appTheme`, icon atlas và nút common, kể cả khi offline.
- Sprite yêu thú, icon chiêu thức và cảnh rừng được đóng gói để xem offline.
  Các thư mục tilesets, maps và audio vẫn trống.
- CI format/analyze/test, hướng dẫn agent, skills và Dart format hook.

```text
lib/
  main.dart
  app/
    pixel_rpg_app.dart
    router/app_router.dart
    theme/app_theme.dart
  features/launch/presentation/{launch_screen,neon_progress_bar}.dart
  features/home/presentation/ # scene, quest panels, dialogue and actions
  features/quests/presentation/ # read-only quest preview
  features/{story,shop,profile,settings,beasts,battle}/presentation/ # interactive UI previews
  app/presentation/ # shared HUD, anchors, scale, menus, controls and pixel/ frame and icon widgets
assets/{branding,ui,sprites,tilesets,maps,audio,fonts}/
test/widget_test.dart
```

Thêm feature dưới `lib/features/<feature>/`; chỉ tạo các lớp presentation,
application, domain, infrastructure khi có code thực tế cần sở hữu.

## Tài liệu concept artwork

[Quy chuẩn UI runtime](docs/art/ui-guidelines.md) là quy tắc bắt buộc cho mọi
màn hiện tại và về sau: palette, kiểu chữ, spacing, shell, navigation, breakpoint,
trạng thái và điều kiện kiểm tra. Menu/hội thoại dùng chung shell, nội dung
thích ứng theo chiều rộng và cỡ chữ. Home là mẫu chuẩn: HUD, hệ số artwork,
viền, vị trí navigation và spacing được dùng lại, không tự dựng một bộ khung
lớn hơn cho menu. Component dùng chung nằm tại `lib/app/presentation/`,
khung và icon common nằm trong `pixel/`; feature chỉ sở hữu nội dung.
Ảnh concept bên dưới chỉ tham chiếu hình ảnh, không cố định layout điện thoại.

[Concept khung UI pixel RPG tái sử dụng](docs/art/reusable-ui-concept.md)
phân tích ảnh mẫu do người dùng cung cấp, tách các khung/panel/nút thành
component và cung cấp prompt để generate từng phần về sau. Đây là tài liệu
định hướng hình ảnh; màn hình chính dùng khung code với sáu skin màu chung
qua `PixelFrame`, với metadata và prompt trong
[assets/ui/README.md](assets/ui/README.md). Nhân vật minh họa được vẽ bằng code; tranh làng và đấu trường rừng nằm trong `assets/scenes/`. Sprite yêu thú và chiêu thức trong `assets/sprites/` là ảnh tĩnh. Các component chưa dùng vẫn
là đề xuất cho các lần triển khai sau.

[Khung layout Nhiệm vụ](docs/art/quest-layout.md) có ảnh dọc 853 × 1280,
ghép từ atlas khung gốc để tham chiếu bố cục tab, danh sách chương và
panel chi tiết. App dựng các vùng này bằng widget và mẫu viền code chung.

[Bốn layout menu](docs/art/menu-layouts.md) có ảnh khung 1024 × 1536 cho
Cốt truyện, Cửa hàng, Hồ sơ và Cài đặt, cùng cách tái tạo ảnh từ atlas khung gốc
và mô tả các luồng xem thử trong app.

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

# Rà soát UI RPG dễ thương — 17/11/2026

Giữ palette tím than, kem, vàng và cyan; làm rõ nội dung trước khi chạm,
giảm khoảng trống ở Home và dùng chung portrait/cảnh làng trên toàn app.
Tranh ImageGen là asset trang trí offline, chữ và control vẫn do Flutter dựng.

Xem [ảnh tổng hợp với palette hiện tại](runtime-preview/overview.jpg).
Các ghi nhận bên dưới thuộc đợt rà soát ngày 17/11/2026.

| Màn | Thay đổi chính | Commit riêng |
| --- | --- | --- |
| Home | Làng hoàng hôn và nhà lữ hành pixel, panel đặc nền dễ đọc | `63a5c9f` |
| Cốt truyện | Thẻ có tên, chương khóa thu gọn, tiến độ rõ | `648962e` |
| Hội thoại | Cảnh nhỏ, tab người nói và giấy lời thoại | `7118d1d` |
| Nhiệm vụ | Chương hiện tại, mục tiêu 1/3, phần thưởng có tên/số | `4253b89` |
| Cửa hàng | Lời chào giấy kem, thẻ tên/giá, danh mục ít quảng bá hơn | `940e3f1` |
| Hồ sơ | Thẻ nhà lữ hành, portrait thống nhất, tên sưu tầm | `4fa3579` |
| Cài đặt | Nhóm âm thanh mặc định, phần trăm rõ, chạm cả hàng công tắc | `df23beb` |
| Khởi động | Quầng tím nhẹ, PRESENTS/loading một dòng | Commit kèm tài liệu này |

Lượt hoàn thiện cuối đồng bộ portrait trong HUD và rút gọn thông báo dữ liệu
mẫu trên mọi menu. Các route, nội dung mẫu và phạm vi gameplay giữ nguyên.
Không thêm dependency, lưu trữ hoặc xử lý game.

## Kiểm tra

- `dart format --output=none --set-exit-if-changed .`: đạt.
- `flutter analyze`: không có issue.
- `flutter test`: 97 tests đạt, gồm route/quay lại, bộ lọc/dialog shop,
  slider/công tắc và các kiểm tra hình học, cỡ chữ, cuộn/navigation.
- `flutter test tool/preview_ui_test.dart`: cập nhật đủ tám ảnh 390 × 844;
  đợi cả atlas icon tải trước khi chụp.
- Render và rà ảnh 64 cấu hình: tám màn × bốn cỡ 320 × 568, 390 × 844,
  844 × 390, 1440 × 900 × chữ 1×/2×. Không có exception layout; chữ lớn
  reflow/cuộn trong cửa sổ giữa và HUD/navigation giữ neo. Màn ngang thấp
  cần cuộn nhiều hơn để đọc hết, đúng với shell hiện tại.
- `flutter build web --release --no-pub`: đạt.
- `flutter build apk --debug --no-pub`: đạt.
- Đã rà diff/status; không đổi dependency hay generated code.

Chưa kiểm tra thao tác trên thiết bị Android thực vì không có thiết bị kết nối.
Computer Use không có browser khả dụng, nên chưa xác minh tương tác bản web
trong browser; build web và ảnh widget không thay thế bước kiểm tra này.

Để tái tạo ảnh đủ cấu hình mà không thêm 64 file vào repo:

```sh
flutter test tool/preview_ui_test.dart \
  --dart-define=EXTENDED=true \
  --dart-define=OUTPUT=/tmp/pixel-rpg-ui-review
```

Có thể thêm `--dart-define=SCREEN=home` để chỉ chụp một màn. Các ảnh là tài
liệu QA, không phải golden khóa implementation hoặc asset runtime.

Ghi nhận ngoài phạm vi: [inventory font cũ](../../deferred-work/2026-11-17-assets-font-inventory.md).
Cảnh báo build về [Cupertino font](../../deferred-work/2026-11-16-web-cupertino-font-warning.md)
và [Android SDK tooling](../../deferred-work/2026-11-16-android-sdk-tooling-warning.md)
đã có issue từ trước; cả hai build vẫn thành công.

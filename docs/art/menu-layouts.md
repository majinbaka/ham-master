# Layout Cốt truyện, Cửa hàng, Hồ sơ và Cài đặt

Bốn ảnh khung **1024 × 1536 (2:3)** giữ tỷ lệ ảnh người dùng cung cấp.
Chỉ tham khảo vị trí và vai trò các vùng; palette tím than, kem, vàng và
viền bậc pixel dùng lại từ [concept hiện tại](reusable-ui-concept.md).
Không lấy nhân vật, yêu thú, bối cảnh, chủ đề thám tử hoặc giá tiền từ ảnh.

| Màn hình | Ảnh khung | Bố cục tham khảo |
| --- | --- | --- |
| Cốt truyện | [story-layout.png](story-layout.png) | HUD, tiêu đề, năm chương bên trái, panel chi tiết/banner/tiến độ/năm bước/nút bắt đầu bên phải, điều hướng đáy. |
| Cửa hàng | [shop-layout.png](shop-layout.png) | HUD, lời chào, năm danh mục, banner gói, bốn ô vật phẩm, ba gói đặc biệt, điều hướng đáy. |
| Hồ sơ | [profile-layout.png](profile-layout.png) | HUD, tiêu đề, chân dung trái/thông tin và EXP phải, bốn chỉ số, bốn ô nhật ký, điều hướng đáy. |
| Cài đặt | [settings-layout.png](settings-layout.png) | HUD, tiêu đề, bảy danh mục trái, panel nhóm âm thanh/hiển thị/điều khiển/tùy chọn phải, điều hướng đáy. |

Ảnh gốc: [Cốt truyện](../../Cốt%20truyện_%20Vụ%20mất%20tích%20bí%20ẩn.png),
[Cửa hàng](../../Cửa%20Hàng%20Phiêu%20Lưu%20Pixel%20Art.png),
[Hồ sơ](../../Hồ%20Sơ%20Nhà%20Lữ%20Hành%20Pixel%20Art.png),
[Cài đặt](../../Vietnamese%20Pixel%20RPG%20Settings%20Screen.png).
Đây là ảnh tham chiếu do người dùng cung cấp, không phải artwork runtime.

## Cách tạo và tích hợp

Giống bản [layout Nhiệm vụ](quest-layout.md), ảnh là khung trống ghép
9-slice từ `assets/ui/frame-atlas.png`; không gọi ImageGen hoặc tạo bộ art mới.
Góc nguồn 56 px thu còn 14 px (giảm với ô nhỏ), cạnh và tâm kéo bằng
nearest-neighbor. Có thể tái tạo cả bốn bằng:

```sh
python3 tools/render_menu_layouts.py
```

Script cần Pillow cho công cụ thiết kế, không phải dependency Flutter.
Các PNG này là tài liệu bố cục, không đăng ký trong `pubspec.yaml`. App ghép
atlas thật bằng `PixelFrame` và icon rời; chữ luôn là widget. Không dùng ảnh
chụp toàn màn hình làm UI. Trên điện thoại, HUD/tab có thể xuống dòng,
cửa hàng dùng hai cột hoặc một cột tùy chiều rộng để giữ chữ đọc được.
Các panel cuộn phía trên thanh điều hướng cố định. Cốt truyện và Cài đặt
giữ hai vùng trái/phải. Màn tối đa 760 dp, có safe area và hỗ trợ chữ lớn.

## Luồng mẫu trong app

Thanh dưới nối Trang chủ, Cốt truyện, Nhiệm vụ, Cửa hàng, Hồ sơ, Cài đặt.
`lib/app/presentation/` sở hữu shell/component menu dùng chung;
`lib/app/router/` sở hữu route. Từng feature chỉ sở hữu presentation.

- `/home/story`: chương 1 được chọn; chương sau và bước sau ghi rõ đã khóa.
  Bắt đầu xem thử mở `/home/story/episode`; quay lại không tăng tiến độ 0/5.
- `/home/shop`: đổi danh mục, mở chi tiết vật phẩm/gói mẫu, đóng hộp thoại.
  Không có thao tác mua, thanh toán hoặc trừ tài nguyên.
- `/home/profile`: xem thông tin, bốn chỉ số, đổi tab sổ sưu tầm/huy hiệu,
  mở chi tiết mẫu hoặc chuyển Cài đặt.
- `/home/settings`: đổi nhóm cài đặt, kéo âm lượng, đổi lựa chọn đồ họa/
  điều khiển và bật/tắt tùy chọn. Đây là state giao diện tạm trong widget,
  mất khi rời màn hình; chưa áp dụng âm thanh, đồ họa hay cấu hình thiết bị.
- `/home/quests`: giữ mục tiêu/phần thưởng mẫu, dùng chung shell điều hướng.

Các màn ghi rõ dữ liệu mẫu và không lưu thay đổi. Những số như cấp 12,
48.720 vàng và tiến trình sưu tầm không phải state game thật; HUD Trang chủ
vẫn dùng dấu `—`. Chưa giới thiệu core, persistence hoặc mock API.

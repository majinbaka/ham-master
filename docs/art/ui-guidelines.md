# Quy chuẩn UI PixelRPG — lấy Home làm chuẩn

Home là mẫu chuẩn về tỷ lệ artwork, mật độ viền, HUD, khoảng cách và cách neo
các cụm UI. Mọi menu dùng lại các component đã tách từ Home. Các ảnh concept
cũ chỉ tham khảo vai trò vùng nội dung; không dùng kích thước pixel của ảnh
làm dp hoặc tự tạo một hệ khung khác cho mỗi màn.

## Một mẫu hình học cho mọi khung

`GameSurfaceStyle` sở hữu duy nhất viền **2 dp** và bán kính góc **8 dp**.
Home, menu, HUD, tab panel, nút chữ/icon, quay lại, dialog và track EXP đều
lấy cùng mẫu này. Màu/nền được đổi theo skin và trạng thái; độ dày, độ cong
không đổi theo feature, selected, disabled, kích thước panel hay text scale.
Track rất thấp dùng cùng bán kính, được Flutter chặn tự nhiên theo nửa chiều cao.

Khung được vẽ bằng code để loại bỏ khác biệt hình học giữa các sprite atlas.
`frame-atlas.png` giữ làm tư liệu art, không còn đóng gói/vẽ trong runtime.
Icon vẫn dùng atlas pixel trong suốt, nearest-neighbor và giữ đúng tỷ lệ.

`GameChromeLayout` giữ hệ tọa độ artwork rộng 940 đơn vị, scale chặn ở
`390 / 940`. `ScaledArtwork` chiếu HUD/tiện ích/hành động và cung cấp
`ArtworkProjection`: viền và góc chia cho scale trước khi vẽ, nên sau phép
chiếu vẫn đúng 2/8 dp như các panel bố trí trực tiếp ở logical pixel.
Không nhân viền/góc theo cỡ icon. Chữ nội dung Home/menu vẫn dùng dp.

Palette giữ nguyên: cảnh làng hoàng hôn tím, mặt khung tím than, chữ kem, điểm nhấn vàng/cyan.
Giấy kem dành cho nội dung đọc. Chỉ dùng `PixelUiColors`, `GameSurfaceStyle`
và theme chung; không tự chọn radius/BorderSide hoặc tạo viền trang trí riêng
ở feature. Icon không thêm nền hay viền riêng bên trong nút.

## Component dùng chung và quyền sở hữu

Tất cả component dùng chung nằm trong `lib/app/presentation/`. Chúng chỉ
hiển thị và gửi callback; feature giữ nội dung và state trình bày, router
ở `lib/app/router/` xử lý điều hướng. App không import widget riêng của Home.

| Component | Vai trò và quy tắc |
| --- | --- |
| `pixel/PixelFrame`, `PixelFrameArtwork` | Khung code dùng `GameSurfaceStyle`; skin chỉ đổi màu/nền, không đổi hình học. |
| `ArtworkProjection` | Bù phép chiếu của `ScaledArtwork` để viền/góc có cùng kích thước thực. |
| `pixel/PixelIcon`, `PixelLabel` | Icon giữ ô vuông kể cả khi cha stretch, nhãn HUD trong slot artwork cố định; không dùng cho nội dung/panel title, không bake chữ vào bitmap. Nhãn đầy đủ vẫn có semantics. |
| `GameSpacing`, `GameChromeLayout` | Lưới artwork và vị trí neo profile, tài nguyên, điều hướng dùng cho cả Home/menu. |
| `PlayerHud`, `ResourceHud`, `ScaledArtwork` | Chính các cụm HUD của Home; cùng kích thước, tỷ lệ và placeholder `—` trên mọi màn. |
| `PixelNavigation` | Sáu mục cùng vị trí neo đáy với Home; một khay `cool`, nút icon 36 dp bo 8 dp; mục đang chọn có viền vàng và dấu tick. |
| `MenuShell` | HUD trên, tiêu đề/quay lại/thông báo xem trước, cửa sổ nội dung giữa và navigation dưới. Chỉ nội dung giữa cuộn. |
| `MenuPanel` | Thân `cool` tím than với tab tiêu đề `gold` nổi như panel Home. `light: true` dùng thân giấy và chữ tối cho nội dung đọc. |
| `MenuButton` | Viền kem 2 dp, góc bo 8 dp, nền tím; có icon thì mặc định hiện icon 36 dp; thẻ nội dung dùng `showLabel` để hiện tên, còn HUD/hành động compact giữ tooltip/semantics. Không có icon thì giữ nhãn chữ 17 dp. Mục chọn có viền vàng và tick; mục khóa giữ icon khóa. |
| `MenuGrid` | Chia ô đều và căn cùng chiều cao từng hàng; bớt cột khi chữ lớn. Hàng cuối giữ cùng bề rộng ô; bốn chỉ số tránh bố cục 3+1. |
| `MenuPreview` | Cửa sổ làng hoàng hôn cao 96 dp, phủ tím than và icon 48 dp; không tạo banner lớn chỉ để lấp chỗ. |
| `PixelProgress` | Thanh EXP cùng mẫu viền 2 dp/góc 8 dp, nền tối và fill vàng như HUD. |

Không sao chép shell/HUD/frame vào feature mới. Nếu thiếu một biến thể thực
sự cần dùng ở nhiều màn, mở rộng component hiện có và kiểm tra lại các màn
đang dùng; không tạo component gần giống với một bộ số đo riêng.

## Bố cục chung

- Áp dụng `SafeArea`. Profile neo trái, tài nguyên neo phải, navigation neo
  giữa đáy theo cùng `GameChromeLayout` ở cả Home và menu. Desktop không
  phóng lớn HUD. Home dùng HUD phủ tranh làng pixel tĩnh với nhà lữ hành đội mũ vàng. Panel Home chừa
  chiều cao cho chữ dp; hội thoại thu bề rộng trên điện thoại nhỏ để không
  đè panel bên khi xoay ngang. Khi hệ số chữ vượt 1.15, Home dùng cửa sổ
  nội dung cuộn của shell chung, giữ HUD/navigation tại cùng neo.
- Menu đặt nội dung dưới HUD và trên navigation, khoảng cách lấy từ
  `GameSpacing`: 10 đơn vị ≈ 4 dp, lề/gap 20 đơn vị ≈ 8 dp ở điện thoại 390.
  Vùng nội dung rộng tối đa 760 dp và căn giữa trên màn lớn.
- Tiêu đề và quay lại nằm ngoài phần cuộn; thông báo xem trước đặt đầu nội dung
  cuộn để chừa chỗ đọc ở màn thấp/chữ lớn. Tiêu đề tối đa hai dòng, ellipsis
  khi thiếu chỗ; nội dung chi tiết giữ đầy đủ. Một cửa sổ
  `cool` chứa một vùng cuộn dọc; không cuộn cả HUD ra khỏi màn hình, không
  tạo vùng cuộn lồng cho từng panel. Không kéo panel chạm vào navigation.
- `MenuColumns` chia vùng chọn–chi tiết 1:2 khi đủ `600 × hệ số chữ` dp
  (đo tại 16 dp); màn hẹp/chữ lớn xếp vùng chọn trước chi tiết.
- Chương hiện tại của Cốt truyện/Nhiệm vụ luôn hiện; các chương khóa nằm
  trong mục mở rộng với `MenuGrid` mặc định: ô tối thiểu
  `140 × hệ số chữ` dp (đo tại 13 dp), tối đa hai cột. Tránh một cột năm
  nút cao đẩy chi tiết ra quá xa. Hàng có nhãn khác số dòng vẫn căn đều.
- Vật phẩm dùng cùng `MenuGrid`. Chỉ số Hồ sơ dùng ô tối thiểu
  `120 × hệ số chữ` dp, tối đa bốn cột; tab và nhóm cài đặt dùng `Wrap`.
- Padding nội dung và khoảng giữa panel/hàng là 8 dp; icon–chữ/tab cách
  4 dp. Lề bảo vệ khung lấy từ độ dày viền chung. Panel cùng cấp phải
  thẳng mép, không co ngang theo độ dài nội dung.

## Chữ và tương tác

Toàn app dùng font `GameRoboto` đóng gói tại `assets/fonts/` (Roboto regular,
medium và bold, kèm giấy phép), kể cả offline trên Android/web. `GameTypography`
và `appTheme` sở hữu cỡ chữ, độ đậm và line height; feature chỉ chọn vai trò
body/heading/value/panelTitle, không tự đặt font riêng. `PixelLabel` chỉ dùng
cho HUD compact (giống nhau trên mọi màn), không dùng cho nhiệm vụ/hội thoại Home.
Nội dung Home và menu đều 17 dp; tiêu đề panel đều 16 dp semibold.
Tiêu đề panel xuống tối đa hai dòng và tăng chiều cao theo text scale, không
co chữ bằng `FittedBox`. Launch giữ bố cục NDAS/neon ba giây trên nền đen với quầng tím than nhẹ, dùng cùng font.
Icon nội dung nổi bật dùng 48 dp, icon trong nút/phần thưởng/chỉ số dùng 36 dp;
HUD giữ kích thước theo hệ tọa độ artwork. Material icon chỉ dùng cho ký hiệu
hệ thống (quay lại, trạng thái chọn/hoàn thành), không thay atlas trang trí.
`GameSurfaceStyle` và theme sở hữu viền/góc bo của TextButton/IconButton,
bao gồm nút đóng dialog. Nút hành động và tiện ích Home dùng `MenuButton`
trực tiếp ở logical pixel với vùng chạm tối thiểu 48 × 48 dp. Icon hành động
giữ tỷ lệ với artwork, viền và góc giữ 2/8 dp.

Nội dung menu 17 dp, line height 1.35; tiêu đề màn 22 dp đậm; tab tiêu đề
panel 16 dp; nút chữ 17 dp. Navigation chỉ hiện icon 36 dp. Icon atlas giữ nền trong
suốt và không có lớp nền/viền bọc riêng; các nút icon compact không hiện chữ, vẫn có
tooltip và semantics. Thẻ chương/đoạn truyện hiển thị tên và trạng thái khóa,
không bắt người chơi đoán nội dung từ icon.
Home dùng ba nút hành động icon lớn, không có nhãn; phần chữ nội dung không
phụ thuộc hệ số artwork. Nói chuyện, Quan sát và Tìm kiếm thay nội dung ô hội
thoại trên Home. Bố cục chữ lớn cuộn tới nội dung mới. Chữ dài trong nội
dung và nút xuống dòng, tăng chiều cao và cuộn được.
Tôn trọng text scaling 1×/2×. `PixelLabel` chỉ fit nhãn HUD compact trong slot cố định; không fit tiêu đề
panel hoặc nội dung đọc. Test đo cỡ chữ sau transform, không chỉ so font family.
Widget test nạp đúng font GameRoboto đóng gói để kiểm tra wrap theo runtime.

Navigation luôn có thứ tự: Trang chủ, Cốt truyện, Nhiệm vụ, Cửa hàng, Hồ sơ,
Cài đặt. Mục đang chọn có semantics, viền vàng và dấu tick. Màn hội thoại
`/home/story/episode` thuộc Cốt truyện.
Nút quay lại menu về Home, hội thoại về danh sách chương. Vùng neo navigation
cao ít nhất 60 dp; nút hoạt động có vùng chạm ít nhất 48 × 48 dp ở màn hình
từ 320 dp, độc lập tỷ lệ sprite. Không chỉ dùng màu để biểu thị khóa/chọn.

Dialog dùng theme tím than/chữ kem và nội dung cuộn. Hộp thoại chi tiết
dùng icon atlas và có nút đóng. Khôi phục cài đặt mẫu có hai nút Hủy và Khôi phục. Các
màn luôn ghi rõ dữ liệu mẫu, không lưu thay đổi; nội dung mẫu không biến
thành chỉ số thật trên HUD. Launch giữ nhận diện NDAS/neon ba giây riêng.

## Ảnh runtime để đối chiếu

Các ảnh 390 × 844 dưới đây được render trực tiếp từ widget Flutter với font
GameRoboto đóng gói và Material Icons của SDK, dùng để rà bố cục. Đây là ảnh QA, không phải
asset UI hoặc golden khóa hành vi; khác biệt font giữa nền tảng vẫn cần kiểm
tra trên Android/web thực. Khi thay concept, cập nhật ảnh tham chiếu cùng code.

| Màn | Tham chiếu |
| --- | --- |
| Khởi động NDAS | [launch.png](runtime-preview/launch.png) |
| Home — mẫu chuẩn | [home.png](runtime-preview/home.png) |
| Home sau khi bấm Nói chuyện | [home-talk.png](runtime-preview/home-talk.png) |
| Cốt truyện | [story.png](runtime-preview/story.png) |
| Nhiệm vụ | [quests.png](runtime-preview/quests.png) |
| Cửa hàng | [shop.png](runtime-preview/shop.png) |
| Hồ sơ | [profile.png](runtime-preview/profile.png) |
| Cài đặt | [settings.png](runtime-preview/settings.png) |
| Hội thoại | [episode.png](runtime-preview/episode.png) |

## Điều kiện duyệt

1. So sánh trực tiếp với Home: cùng HUD, viền 2 dp/góc 8 dp và vị trí navigation.
   Không chấp nhận chỉ trùng palette nhưng khác tỷ lệ khung.
2. Xem ảnh render mọi màn ở điện thoại, ngang và desktop để kiểm tra mép
   panel, hàng ô, icon–chữ, contrast và khoảng cách. Không chỉ dựa vào việc
   widget test không ném exception.
3. Test 320 × 568, 390 × 844, 844 × 390, 1440 × 900 và chữ 1×/2×;
   không overflow/chồng panel, phần cuối nội dung vẫn cuộn tới được.
4. Kiểm tra chọn tab/nhóm, route, quay lại, dialog; cuộn không dịch chuyển
   HUD, tiêu đề hoặc navigation. Kiểm tra Android/web thực khi có thiết bị.
5. Test pixel kiểm tra đúng hai hàng viền và silhouette góc khi đổi skin,
   kích thước và projection; kiểm tra shape của nút/quay lại/dialog.
6. Chạy format/analyze/test theo `AGENTS.md`. Thay đổi quy tắc dùng chung
   phải sửa component, regression test và tài liệu này trong cùng thay đổi.

## Đợt làm đẹp RPG dễ thương

Theo yêu cầu làm lại toàn bộ UI, Home dùng tranh làng hoàng hôn tạo bằng
ImageGen; đây là cảnh minh họa, không phải bản đồ tương tác. Menu dùng cùng
tranh nhưng phủ tím than 86% để chữ rõ. Nhân vật là portrait pixel vẽ bằng code,
không có animation hoặc trạng thái gameplay. Giữ nguyên khung 2/8 dp, màu sẵn
và neo HUD/navigation. Chạy `flutter test tool/preview_ui_test.dart` để cập nhật
ảnh; thêm `--dart-define=EXTENDED=true` để rà đủ kích thước/chữ lớn.

Cốt truyện dùng thẻ icon kèm tên chương/đoạn, khóa hiển thị cả chữ và icon.
Thanh tiến độ đặt dưới mô tả chương; cảnh minh họa nhỏ dùng lại tranh Home.

Ở Cốt truyện, chương hiện tại luôn hiện; các chương khóa nằm trong mục mở rộng
để không đẩy mô tả và nút bắt đầu quá xa trên điện thoại.

Hội thoại tách cảnh minh họa, giấy lời thoại có tab tên người nói và ghi chú
xem trước. Nút về danh sách chương nằm sau lời thoại, giữ đường quay lại trên header.

Nhiệm vụ ưu tiên chương hiện tại, các chương khóa thu gọn. Mục tiêu mẫu có
tiến độ 1/3, checkbox lớn và phần thưởng kèm tên/số lượng trong lưới hai cột.

Cửa hàng dùng giấy kem cho lời chào, thẻ vật phẩm hiện icon + tên + giá mẫu +
nhãn xem chi tiết. Gói khởi hành chỉ hiện ở Đề cử để bộ lọc đi thẳng vào hàng
đang chọn; các gói khác dùng cùng lưới thẻ có tên. Không có mua/thanh toán.

Hồ sơ dùng thẻ giấy kem với portrait nhà lữ hành cùng Home, tên/ID mẫu và EXP.
Các mục sưu tầm/huy hiệu dùng lưới có tên để nhận biết trước khi chạm.

Cài đặt mở nhóm Âm thanh để tránh trộn mọi điều khiển vào một trang dài.
Âm lượng có tên bên trái, phần trăm vàng bên phải và track 8 dp. Công tắc
dùng cả hàng nhãn làm vùng chạm; chữ được xuống dòng theo text scale.

Portrait trong HUD dùng cùng nhà lữ hành với Home/Hồ sơ; kích thước slot HUD
và placeholder tài nguyên vẫn giữ nguyên, không lấy chỉ số hồ sơ mẫu làm state.

Thông báo đầu vùng cuộn rút gọn thành “Dữ liệu mẫu · Không lưu thay đổi” để
nhường chỗ đọc khi chữ lớn. Caption thương hiệu và loading giữ một dòng,
fit trong cụm NDAS; nội dung đọc của các menu vẫn tăng theo text scale.

[Ảnh tổng hợp tám màn](runtime-preview/overview.jpg) giữ lưới bốn cột
của bản tham chiếu. [Ảnh tổng hợp 39 hộp thoại](runtime-preview/overview-modals.jpg)
và [ảnh hộp thoại riêng](runtime-preview/modals/) được chụp bằng cách bấm
các nút trong giao diện Flutter. Hộp thoại dùng khung 390 × 844 và cỡ chữ 1×.

```sh
flutter test tool/preview_ui_test.dart
python3 tools/render_runtime_overview.py
```

Kết quả kiểm tra đợt này: [cozy-ui-review.md](cozy-ui-review.md).

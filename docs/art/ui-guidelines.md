# Quy chuẩn UI PixelRPG — lấy Home làm chuẩn

Home là mẫu chuẩn về tỷ lệ artwork, mật độ viền, khoảng cách và cách neo
các cụm UI. Mọi menu dùng lại các component đã tách từ Home. Các ảnh concept
cũ chỉ tham khảo vai trò vùng nội dung; không dùng kích thước pixel của ảnh
làm dp hoặc tự tạo một hệ khung khác cho mỗi màn.

## Một mẫu hình học cho mọi khung

`GameSurfaceStyle` sở hữu duy nhất viền **2 dp** và bán kính góc **8 dp**.
Home, menu, tab panel, nút chữ/icon, quay lại, dialog và track EXP đều
lấy cùng mẫu này. Màu/nền được đổi theo skin và trạng thái; độ dày, độ cong
không đổi theo feature, selected, disabled, kích thước panel hay text scale.
Track rất thấp dùng cùng bán kính, được Flutter chặn tự nhiên theo nửa chiều cao.

Khung được vẽ bằng code để loại bỏ khác biệt hình học giữa các sprite atlas.
`frame-atlas.png` giữ làm tư liệu art, không còn đóng gói/vẽ trong runtime.
Icon vẫn dùng atlas pixel trong suốt, nearest-neighbor và giữ đúng tỷ lệ.

`GameChromeLayout` giữ hệ tọa độ artwork rộng 940 đơn vị, scale chặn ở
`390 / 940`. `ArtworkProjection` bù viền và góc khi chiếu khung artwork
để giữ đúng 2/8 dp như các panel bố trí trực tiếp ở logical pixel.
Không nhân viền/góc theo cỡ icon. Chữ nội dung Home/menu vẫn dùng dp.

Cảnh làng ban ngày dùng xanh lá, xanh trời, mái ngói đất nung và hoa nhiều màu.
Khung dùng nền kem, bạc hà và xanh trời nhạt với chữ xanh đậm. Vàng mật ong
dành cho tiêu đề và tiến độ. Nút có khung dùng nền đục, màu rõ hơn panel và
viền xanh đậm. Nút thường dùng nền vàng cát. Các nút hội thoại Home dùng
vàng, xanh trời, bạc hà. Nút Trận chiến và mục đang chọn dùng cam đào đậm.
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
| `pixel/PixelIcon` | Icon giữ ô vuông kể cả khi widget cha giãn. Chữ hiển thị bằng widget, nhãn điều khiển có semantics. |
| `GameSpacing`, `GameChromeLayout` | Lưới artwork và vị trí neo thanh nhân vật, điều hướng dùng cho cả Home/menu. |
| `PlayerHud` | Thanh nhân vật dùng chung gồm chân dung, tên, cấp và EXP. `ScaledArtwork` giữ tỷ lệ theo ô thiết kế 440 × 120. |
| `PixelNavigation` | Bốn mục cùng vị trí neo đáy với Home; một khay `cool`, nút icon 36 dp bo 8 dp; mục đang chọn có nền cam đào đậm và semantics báo trạng thái chọn. |
| `MenuShell` | Khung giấy kem nằm giữa thanh nhân vật và thanh điều hướng. Hồ sơ dùng ảnh nền toàn màn hình, đặt hàng tiêu đề ở mép trên vùng an toàn. Chỉ nội dung dưới tiêu đề cuộn. |
| `MenuPanel` | Thân `cool` xanh bạc hà với tab tiêu đề `gold` nổi như panel Home. `light: true` dùng thân giấy và chữ tối cho nội dung đọc. |
| `MenuButton` | Viền xanh đậm 2 dp, góc bo 8 dp, mặc định nền vàng cát; icon atlas mặc định 36 dp; thẻ có thể truyền sprite trang trí và dùng `showLabel` để hiện tên, còn nút hành động compact giữ tooltip/semantics. Không có icon thì giữ nhãn chữ 17 dp. Mục chọn có nền cam đào đậm và semantics báo trạng thái chọn; mục khóa giữ icon khóa. |
| `MenuGrid` | Chia ô đều và căn cùng chiều cao từng hàng; bớt cột khi chữ lớn. Hàng cuối giữ cùng bề rộng ô. |
| `PixelProgress` | Thanh EXP cùng mẫu viền 2 dp/góc 8 dp, nền xanh đậm và phần đã đạt mặc định màu vàng mật ong. Thanh HP dùng màu theo hai phía của trận chiến. |

Không sao chép shell/frame vào feature mới. Nếu thiếu một biến thể thực
sự cần dùng ở nhiều màn, mở rộng component hiện có và kiểm tra lại các màn
đang dùng; không tạo component gần giống với một bộ số đo riêng.

## Bố cục chung

- Áp dụng `SafeArea`. Thanh nhân vật neo góc trên bên trái và thanh điều
  hướng neo giữa đáy theo cùng `GameChromeLayout` ở Home và các menu có thanh
  nhân vật. Hồ sơ dùng cùng vị trí neo thanh điều hướng. Home dùng tranh làng pixel tĩnh với nhà lữ hành đội mũ
  vàng và biểu tượng Hộp thư neo góc trên bên phải. Panel Home chừa chiều cao
  cho chữ dp và ô hội thoại thu bề rộng trên điện thoại nhỏ. Khi hệ số chữ
  vượt 1.15, Home dùng cửa sổ nội dung cuộn của shell chung, với Hộp thư
  ở góc trên bên phải của cảnh trong vùng cuộn. Thanh nhân vật và thanh điều
  hướng giữ nguyên vị trí khi cuộn.
- Menu đặt nội dung dưới thanh nhân vật và trên thanh điều hướng. Trên điện
  thoại rộng 390 dp, một bước `GameSpacing` là khoảng 4 dp và khoảng cách
  giữa các cụm là khoảng 8 dp.
  Vùng nội dung rộng tối đa 760 dp và căn giữa trên màn lớn.
- Tiêu đề và quay lại dùng chung hàng cố định ở đầu vùng nội dung.
  Ô nút quay lại rộng 36 dp với vùng chạm tối thiểu 48 × 48 dp. Tiêu đề
  tối đa hai dòng và dùng dấu ba chấm khi thiếu chỗ. Vùng cuộn bắt đầu ngay
  dưới hàng tiêu đề, từ thông báo xem trước đến hết nội dung chi tiết.
  Dùng một vùng cuộn dọc và chừa khoảng cách với navigation.
- `MenuColumns` chia vùng chọn–chi tiết 1:2 khi đủ `600 × hệ số chữ` dp
  (đo tại 16 dp); màn hẹp/chữ lớn xếp vùng chọn trước chi tiết.
- Vật phẩm dùng cùng `MenuGrid`. Tab và nhóm cài đặt dùng `Wrap` để
  xuống hàng khi hẹp hoặc chữ lớn.
- Tab lọc và lựa chọn cài đặt dùng `MenuButton.tab` với padding ngang 6 dp,
  dọc 4 dp và khung cao tối thiểu 40 dp. Vùng chạm tối thiểu 48 × 48 dp.
  Khung tăng chiều cao khi nhãn xuống dòng hoặc chữ được phóng to.
- Padding nội dung và khoảng giữa panel/hàng là 8 dp; icon–chữ/tab cách
  4 dp. Lề bảo vệ khung lấy từ độ dày viền chung. Panel cùng cấp phải
  thẳng mép, không co ngang theo độ dài nội dung.

## Chữ và tương tác

Toàn app dùng font `GameRoboto` đóng gói tại `assets/fonts/` (Roboto regular,
medium và bold, kèm giấy phép), kể cả offline trên Android/web. `GameTypography`
và `appTheme` sở hữu cỡ chữ, độ đậm và line height; feature chỉ chọn vai trò
body/heading/value/panelTitle theo theme chung. `PixelLabel` dùng cho
nhãn nằm trong ô artwork cố định của thanh nhân vật.
Nội dung Home và menu đều 17 dp; tiêu đề panel đều 16 dp semibold.
Tiêu đề panel xuống tối đa hai dòng và tăng chiều cao theo text scale, không
co chữ bằng `FittedBox`. Launch giữ bố cục NDAS ba giây, dùng nền tím than chuyển đen và thanh tiến độ vàng đào.
Icon nội dung nổi bật dùng 48 dp, icon trong nút/phần thưởng/chỉ số dùng 36 dp;
Material icon dùng cho ký hiệu hệ thống như quay lại.
`GameSurfaceStyle` và theme sở hữu viền/góc bo của TextButton/IconButton,
bao gồm nút đóng dialog. Hộp thư hiện biểu tượng phong bì 32 dp trên vùng
chạm trong suốt 48 × 48 dp, có tooltip và semantics. Nút hành động Home
dùng `MenuButton` với vùng chạm tối thiểu 48 × 48 dp. Icon hành động
giữ tỷ lệ với artwork, viền và góc giữ 2/8 dp.

Nội dung menu 17 dp, line height 1.35; tiêu đề menu 18 dp đậm; tab tiêu đề
panel 16 dp; nút chữ 17 dp. Navigation chỉ hiện icon 36 dp. Icon atlas giữ nền trong
suốt và không có lớp nền/viền bọc riêng; các nút icon compact không hiện chữ, vẫn có
tooltip và semantics. Thẻ chương/đoạn truyện hiển thị tên và trạng thái khóa,
không bắt người chơi đoán nội dung từ icon.
Home dùng bốn nút hành động icon lớn với tên trong tooltip; phần chữ nội dung không
phụ thuộc hệ số artwork. Nói chuyện, Quan sát và Tìm kiếm thay nội dung ô hội
thoại trên Home. Trận chiến mở đấu trường. Bố cục chữ lớn cuộn tới nội dung mới. Chữ dài trong nội
dung và nút xuống dòng, tăng chiều cao và cuộn được.
Tôn trọng text scaling 1×/2×. Tiêu đề panel và nội dung đọc giữ cỡ chữ theo
hệ số chữ. Widget test đo cỡ chữ sau transform.
Widget test nạp đúng font GameRoboto đóng gói để kiểm tra wrap theo runtime.

Navigation theo thứ tự Trang chủ, Cửa hàng, Hồ sơ và Cài đặt.
Mục đang chọn có nền cam đào đậm và semantics báo trạng thái chọn.
Nút quay lại menu về Home, Yêu thú về Hồ sơ và Trận chiến về màn đã
mở bản xem thử. Vùng neo navigation cao ít nhất 60 dp; nút hoạt động có vùng chạm ít nhất 48 × 48 dp ở màn hình
từ 320 dp, độc lập tỷ lệ sprite. Trạng thái khóa có icon khóa.

Dialog dùng nền giấy kem, chữ xanh đậm và nội dung cuộn. Hộp thoại chi tiết
dùng icon atlas và có nút đóng. Khôi phục cài đặt mẫu có hai nút Hủy và Khôi phục. Các
menu mẫu ghi rõ dữ liệu minh họa. Hồ sơ lưu tùy chọn hiển thị thẻ. Launch giữ nhận diện NDAS ba giây.

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
| Cửa hàng | [shop.png](runtime-preview/shop.png) |
| Hồ sơ | [profile.png](runtime-preview/profile.png) |
| Cài đặt | [settings.png](runtime-preview/settings.png) |
| Danh sách yêu thú | [beasts.png](runtime-preview/beasts.png) |
| Trận chiến | [battle.png](runtime-preview/battle.png) |

## Điều kiện duyệt

1. So sánh trực tiếp với Home. Kiểm tra viền 2 dp/góc 8 dp, vị trí navigation
   và thanh nhân vật ở các menu có dùng thanh này.
   Không chấp nhận chỉ trùng palette nhưng khác tỷ lệ khung.
2. Xem ảnh render mọi màn ở điện thoại, ngang và desktop để kiểm tra mép
   panel, hàng ô, icon–chữ, contrast và khoảng cách. Không chỉ dựa vào việc
   widget test không ném exception.
3. Test 320 × 568, 390 × 844, 844 × 390, 1440 × 900 và chữ 1×/2×;
   không overflow/chồng panel, phần cuối nội dung vẫn cuộn tới được.
4. Kiểm tra chọn tab/nhóm, route, quay lại, dialog; cuộn không dịch chuyển
   thanh nhân vật khi có, tiêu đề hoặc navigation. Kiểm tra Android/web thực khi có thiết bị.
5. Test pixel kiểm tra đúng hai hàng viền và silhouette góc khi đổi skin,
   kích thước và projection; kiểm tra shape của nút/quay lại/dialog.
6. Chạy format/analyze/test theo `AGENTS.md`. Thay đổi quy tắc dùng chung
   phải sửa component, regression test và tài liệu này trong cùng thay đổi.

## Đợt làm đẹp RPG dễ thương

Home dùng tranh làng ban ngày tạo bằng ImageGen dựa trên bố cục làng cũ.
Các menu dùng khung giấy kem đặt trên cùng tranh với lớp kem có độ đục 56%.
Hồ sơ dùng cảnh nền và lớp phủ riêng. Nhân vật là portrait pixel tĩnh vẽ bằng code. Khung dùng
viền 2 dp, góc 8 dp và thanh điều hướng dùng chung vị trí neo. Chạy `flutter test tool/preview_ui_test.dart` để cập nhật
ảnh; thêm `--dart-define=EXTENDED=true` để rà đủ kích thước/chữ lớn.

Cửa hàng dùng giấy kem cho lời chào, thẻ vật phẩm hiện icon + tên + giá mẫu +
nhãn xem chi tiết. Gói khởi hành chỉ hiện ở Đề cử để bộ lọc đi thẳng vào hàng
đang chọn; các gói khác dùng cùng lưới thẻ có tên. Không có mua/thanh toán.

Hồ sơ dùng cảnh đã chọn phủ hết màn hình, kể cả phía sau phần chừa cho
hệ thống. Cảnh đứng yên khi cuộn. Chân dung và yêu thú đồng hành nằm trực
tiếp trên cảnh. Tên, số yêu thú trong danh sách mẫu và mã QR nằm trong một
cụm xanh đậm bán trong suốt, ở dưới vùng ảnh trên màn hẹp và bên phải khi
đủ rộng. Cả thẻ vừa trong vùng nhìn đầu tiên. Nút chỉnh sửa và chia sẻ
nằm ở hàng tiêu đề. Cuộn xuống để xem sổ sưu tầm. Ảnh PNG gồm cảnh nền và
thẻ trưng bày.

Yêu thú dùng cùng `MenuColumns` cho danh sách và chi tiết. Chạm một thẻ
đưa phần chi tiết vào vùng nhìn ở điện thoại. Chỉ số và chiêu dùng `MenuGrid`.
Hồ sơ mở Yêu thú. Trang chủ và Yêu thú đều mở Trận chiến.

Trận chiến dùng cảnh rừng phủ toàn màn hình. Nút quay lại neo góc trên trái
và ba nút chiêu đánh neo giữa đáy trong vùng an toàn. Hai sprite có HP mẫu
đặt cạnh bằng `PixelProgress`, với màu nhấn theo hai phía và số HP bằng chữ.
Chọn biểu tượng chiêu rồi chạm đối thủ để xem hiệu ứng. Đấu trường dùng
cùng kiểu khung và nút với Home, với toàn bộ điều khiển hiện trong khung nhìn.

Cài đặt có ba tab Tài khoản, Chung và Thông tin, mở mặc định ở Tài khoản.
Trong tab Chung, âm lượng có tên bên trái, phần trăm màu nâu hổ phách bên phải
và track 8 dp. Công tắc
dùng cả hàng nhãn làm vùng chạm; chữ được xuống dòng theo text scale.

Thông báo đầu vùng cuộn của các menu mẫu dùng “Dữ liệu mẫu · Không lưu thay đổi” để
nhường chỗ đọc khi chữ lớn. Caption thương hiệu và loading giữ một dòng,
fit trong cụm NDAS; nội dung đọc của các menu vẫn tăng theo text scale.

[Ảnh tổng hợp bảy màn](runtime-preview/overview.jpg) giữ lưới bốn cột
của bản tham chiếu. [Ảnh tổng hợp 20 hộp thoại](runtime-preview/overview-modals.jpg)
và [ảnh hộp thoại riêng](runtime-preview/modals/) được chụp bằng cách bấm
các nút trong giao diện Flutter. Hộp thoại dùng khung 390 × 844 và cỡ chữ 1×.

```sh
flutter test tool/preview_ui_test.dart
python3 tools/render_runtime_overview.py
```

[Ghi nhận đợt rà soát giao diện trước khi đổi palette](cozy-ui-review.md).

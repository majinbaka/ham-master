# Concept khung giao diện pixel RPG tái sử dụng

Quy tắc triển khai cho mọi màn hình nằm ở [Quy chuẩn UI](ui-guidelines.md).
Tài liệu này giữ vai trò art direction và prompt; kích thước ảnh không phải
ràng buộc bố cục runtime. Trang chủ giữ HUD neo cảnh, menu dùng layout thích ứng.

## Mục đích và phạm vi

Chuyển cách xử lý thị giác của ảnh mẫu thành một bộ khung có thể generate
riêng từng phần và ghép lại cho game sau này. Đây là **tài liệu art direction
và prompt** cho các component tái sử dụng.

Màn hình chính tại `lib/features/home/presentation/` dùng palette và bố cục
Home với khung code chung: viền 2 dp, góc 8 dp từ `GameSurfaceStyle`.
`ArtworkProjection` bù scale để HUD, panel, nút và dialog có cùng hình học.
Sau loading 3 giây, app chuyển sang Home với cảnh làng ban ngày tĩnh, portrait nhà lữ hành vẽ bằng code,
chưa có gameplay. Sáu skin chỉ đổi màu/nền. Chữ là widget riêng; 18 icon dùng
atlas trong suốt `assets/ui/icon-atlas.png`. Atlas khung cũ giữ làm tư liệu art,
không còn đóng gói runtime. Các quy tắc generate bên dưới là art direction,
không thay thế mẫu hình học runtime trong `ui-guidelines.md`.
Thông số nguồn thực tế, vùng cắt và prompt đã dùng nằm ở
[assets/ui/README.md](../../assets/ui/README.md). Đây là bộ khung chung đầu tiên;
chưa triển khai toàn bộ silhouette riêng của F01–F16. Các prompt bên dưới
vẫn là định hướng cho những component chi tiết chưa tạo.

Ở cỡ chữ thường, Trang chủ giữ vị trí các cụm theo ảnh mẫu: hồ sơ/nhiệm vụ
neo trái, tài nguyên/tiện ích neo phải, hội thoại/nút hành động/thanh dưới neo
ở giữa. Nhiệm vụ luôn xếp dọc và sáu mục điều hướng luôn trên một hàng. Khi xoay ngang, các cụm dịch sang cạnh hoặc giữ trục giữa, không
kéo giãn hay thu nhỏ theo chiều cao. Tranh làng nhận phần không gian dư.
`HomeLayout` mở rộng `GameChromeLayout` dùng đơn vị thiết kế theo chiều rộng ảnh mẫu 940; hệ số chung
được chặn ở 390/940 và chỉ giảm theo chiều ngắn thiết bị nhỏ hơn 390 dp.
Khoảng cách giữa các cụm được thu gọn trên cửa sổ thấp, hẹp; kích thước khung
không đổi khi xoay. Chỉ nhãn HUD compact fit trong slot cố định. Nhiệm vụ,
bản đồ và hội thoại dùng MenuPanel ở dp, cùng cỡ nội dung 17 dp và tiêu đề
16 dp như menu. Chữ lớn hơn 1.15× dùng shell cuộn chung, giữ HUD/navigation.

Ảnh tham chiếu: [Pixel Detective Office — Mira’s New Clue](../../Pixel%20Detective%20Office_%20Mira%E2%80%99s%20New%20Clue.png).
Ảnh do người dùng cung cấp; đường dẫn cần giữ cùng repo để xem lại tham chiếu.

Chỉ kế thừa **ngôn ngữ tạo hình của khung**. Chủ đề thám tử, Mira, tên thành
phố, nhiệm vụ, tài nguyên và các chức năng trong ảnh không phải scope gameplay.

Bao gồm: nền panel, đường viền, góc, vùng chứa trống, nút trống, thanh tiến
trình, tab, badge và các lớp trạng thái. Không bao gồm nhân vật, quái, thú,
chân dung, bản đồ, tranh khung cảnh, đồ nội thất hoặc đạo cụ trong cảnh.
Icon minh họa như túi, kiếm, sách, tiền, kim cương cũng không nằm trong bộ này.
Chữ, con số và nội dung icon sẽ được đặt độc lập khi dựng game.

## 1. Phong cách của ảnh mẫu gốc

**Tinh thần:** pixel RPG thân thiện, ấm áp; khung đủ nổi bật trên nền nhiều
chi tiết, có cảm giác vật thể nhỏ với viền sáng và bóng đổ gọn.

| Quan sát từ ảnh | Quy tắc dùng lại |
| --- | --- |
| HUD, nhiệm vụ, minimap và thanh dưới có nền tím than | Dùng một họ nền tối thống nhất cho các khối điều khiển. |
| Viền sáng nhiều lớp, góc cắt thành bậc | Giữ silhouette rõ: viền ngoài tối → viền sáng → mép trong tối. |
| Khung nhiệm vụ có phần tiêu đề nhô lên như tab hồ sơ | Tách tab/đầu panel khỏi phần thân; không khóa vào độ dài một câu chữ. |
| Nhiệm vụ chính và nút chọn dùng vàng; nhiệm vụ phụ dùng cyan | Vàng cho trọng tâm/đang chọn, cyan cho thông tin phụ; không tô mọi khung cùng màu nhấn. |
| Hộp thoại nền kem khác hẳn các khối tối | Có một biến thể panel sáng dành cho nội dung dài, độc lập với chân dung. |
| Nút có mặt sáng hơn cạnh dưới; lựa chọn có viền phát sáng | Dùng bevel pixel và bóng ngắn; glow chỉ là lớp nhấn tùy chọn. |
| Nội dung chữ mượt hơn phần artwork pixel | Không ép chữ thành bitmap pixel; khung và chữ là hai lớp riêng. |

Không lấy gạch tường, sàn gỗ, cây, ánh sáng căn phòng hoặc biển văn phòng làm
texture UI. Độ ấm đến từ màu viền và điểm nhấn, không từ tranh cảnh gắn vào panel.
Không mô tả toàn bộ giao diện là pixel art thuần tuyệt đối: ảnh mẫu có cả chữ
mượt và glow. Bộ khung đề xuất sẽ tiết chế glow để dễ tái sử dụng ở cỡ nhỏ.

## 2. Quy chuẩn đề xuất cho các lần generate

Các mã màu, kích thước và độ dày dưới đây là **đề xuất để giữ nhất quán**,
không phải số đo trích chính xác từ ảnh hoặc thông số đã chốt cho runtime.

### Palette khởi đầu

| Token | Màu gợi ý | Công dụng |
| --- | --- | --- |
| `outline.deep` | `#211B32` | Viền ngoài và khe tối. |
| `surface.dark` | `#302B46` | Mặt panel/HUD. |
| `surface.raised` | `#45405D` | Mặt nút, tab, vùng nổi. |
| `edge.cool` | `#9CAED9` | Viền HUD/thanh điều hướng. |
| `edge.cream` | `#F4D9A3` | Viền panel và nút thông thường. |
| `accent.gold` | `#FFD15A` | Nhiệm vụ chính, trạng thái chọn. |
| `shadow.gold` | `#AA6A30` | Mặt tối của viền vàng. |
| `accent.cyan` | `#65DDEB` | Điểm nhấn phụ. |
| `surface.paper` | `#FFF2E5` | Mặt hộp thoại sáng. |
| `alert.red` | `#ED555B` | Badge thông báo. |

### Hình khối, ánh sáng và mật độ chi tiết

- Nhìn chính diện, phẳng theo màn hình; không phối cảnh/isometric cho asset UI.
- Góc cắt bậc vuông hoặc bo giả bằng bậc pixel, không bo vector trơn.
- Ở bản logic tham khảo: viền ngoài 1 px, viền sáng 1–2 px, mép trong 1 px.
  Dùng chung độ dày giữa các component; số này là pixel artwork, không phải dp.
- Cạnh trên/trái sáng hơn, cạnh dưới/phải tối hơn. Bóng đổ ngắn, cùng hướng.
- Mặt trong ít chi tiết, chênh màu nhẹ; tránh vân, hạt nhiễu và phản chiếu bóng.
- Góc trang trí nhỏ chỉ dùng cho panel lớn; nút nhỏ ưu tiên hình rõ.
- Glow vàng là lớp tùy chọn tách riêng, không làm mềm đường viền pixel gốc.
- Khi chuẩn hóa asset, dùng lưới pixel thống nhất và phóng theo bội số nguyên.
  Kích thước output của công cụ generate chưa bảo đảm đúng lưới pixel logic.

## 3. Tách ảnh mẫu thành các component

Mỗi mã bên dưới đại diện cho một asset hoặc một nhóm lớp cùng chức năng.
“Vùng trống” là nơi sau này đặt nội dung; không generate nội dung giả vào đó.

| Mã | Component / vị trí trong ảnh | Phần cần giữ | Phần loại khỏi artwork |
| --- | --- | --- | --- |
| F01 | Khung hồ sơ ở góc trên trái | Panel ngang tối, cạnh phải cắt bậc, viền lạnh | Avatar, tên, level, chữ EXP. |
| F02 | Viền avatar nằm trên F01 | Vòng khung gần tròn bằng bậc pixel, tâm trong suốt | Người, nền chân dung. |
| F03 | Khay chỉ số ở góc trên phải | Khay ngang dạng capsule pixel, mặt tối, chỗ trống ở hai đầu | Tiền/ngọc/năng lượng, số, dấu cộng. |
| F04 | Thanh EXP trong F01 | Track rỗng và lớp fill cyan riêng | Nhãn, số, giá trị tiến trình cố định. |
| F05 | Cụm nhiệm vụ chính/phụ bên trái | Thân panel tối, tab tiêu đề nhô lên, đường phân cách; hai màu viền | Sách, dấu nhiệm vụ, checkbox, chữ. |
| F06 | Ba nút tiện ích trên minimap | Nút vuông cắt góc, mặt tím than, bevel | Thư, danh sách, bánh răng, badge gắn sẵn. |
| F07 | Badge đỏ trên nút và tab | Huy hiệu tròn pixel, viền sáng, ruột đỏ | Dấu chấm than, số đếm. |
| F08 | Khung minimap bên phải | Viền chữ nhật, góc bậc, header tối riêng, cửa sổ rỗng | Tranh map, cây/nhà, pin, chữ và icon. |
| F09 | Nút tròn góc dưới minimap | Nền nút tròn pixel tối, viền sáng | Kính lúp. |
| F10 | Bong bóng phía trên NPC | Vỏ bong bóng kem, viền tối, đuôi ngắn | Ba dấu chấm và NPC. |
| F11 | Nhãn “Nhấn để nói chuyện” | Khay nhãn ngang màu nâu tối, viền kem, đầu cắt góc | Chữ, bàn tay, tia sáng và vòng dưới chân. |
| F12 | Hộp hội thoại ở gần đáy | Thân panel kem lớn, viền tím, bóng gọn | Chân dung, tên, câu thoại, mũi tên tiếp tục. |
| F13 | Tab tên gắn trên F12 | Tab tím than, viền kem, góc bậc | Tên nhân vật và chân dung. |
| F14 | Ba nút hành động dưới hội thoại | Nút ngang tối, viền kem; biến thể chọn vàng | Icon, nhãn chức năng. |
| F15 | Khung điều hướng dưới cùng | Một nền ngang dài, viền xanh tím, góc bậc, vùng chứa trống | Sáu icon, nhãn, badge và ô được chọn. |
| F16 | Ô chọn trong F15 | Tile nền vàng, viền sáng, góc bậc, glow tùy chọn | Icon nhà và chữ. |

F01 và F03 không cần khoét vị trí icon vào hình khung: đó là khoảng bố cục.
F05 dùng chung cấu trúc cho chính/phụ, chỉ đổi viền và kích thước cần thiết.
F12 có thân chữ nhật hoàn chỉnh, không tạo lỗ hoặc silhouette ôm một nhân vật.
F15 không vẽ cố định sáu ô: số mục điều hướng được quyết định khi dựng game.

### Họ component để tránh generate trùng

| Họ gốc | Biến thể / tổ hợp |
| --- | --- |
| `panel.dark` | F01, thân F05, header F08. |
| `panel.light` | F12; F10 là biến thể bong bóng có đuôi. |
| `button.frame` | F06 vuông, F09 tròn, F14 chữ nhật. |
| `label.frame` | F03 capsule, F11 nhãn ngữ cảnh, F13 tab tên. |
| `frame.viewport` | F02 chân dung và F08 cửa sổ bản đồ, đều rỗng ở giữa. |
| `navigation.frame` | F15 nền chứa + F16 lớp chọn độc lập. |
| `indicator.frame` | F04 track/fill + F07 badge trống. |

Các họ dùng chung màu, ánh sáng, độ dày viền; không ép mọi hình thành một
asset duy nhất nếu silhouette khác nhau.

## 4. Cấu tạo lớp và khả năng co giãn

Tách logic artwork thành: **shadow → surface → border → state overlay**.
Icon, chữ, số và ảnh nội dung nằm phía trên, không thuộc file khung.
Không bắt buộc xuất mỗi lớp thành một file nếu không có nhu cầu thay đổi riêng.

| Loại | Alpha và nền | Cách tái sử dụng dự kiến |
| --- | --- | --- |
| Panel, nút, khay, tab | Ngoài silhouette trong suốt; phần mặt trong có màu | Co giãn phần thân, bảo toàn góc/viền. |
| Viền chân dung F02 | Ngoài và toàn bộ tâm đều trong suốt | Giữ tỷ lệ vuông; thay ảnh ở lớp dưới. |
| Cửa sổ F08 | Ngoài khung và vùng tranh trong suốt; header có nền tối | Ghép header và cửa sổ riêng; đặt map/ảnh dưới cửa sổ sau. |
| Badge và bong bóng | Ngoài trong suốt, ruột có màu | Giữ tỷ lệ; tách đuôi bong bóng nếu cần thay hướng. |
| Track/fill F04 | Hai lớp riêng, ngoài trong suốt | Clip độ dài fill theo dữ liệu; không kéo giãn cả track. |
| Selected overlay/glow | Ngoài trong suốt, không có chữ/icon | Chồng đúng kích thước lên frame tương ứng. |

Ảnh concept chữ nhật từng dùng **9-slice**; atlas đã được đo vùng nguồn,
lưu metadata trong tài liệu asset. Runtime hiện vẽ khung bằng code để mọi
skin có cùng độ dày và độ cong. Không suy ra kích thước runtime từ atlas.
Tab nhô, hoa văn góc và đuôi bong bóng phải ở ngoài vùng được kéo giãn.
F03 dạng capsule có thể dùng ba phần trái–giữa–phải; F02/F07/F09 giữ tỷ lệ.

### Trạng thái cần đồng bộ

| Trạng thái | Cách xử lý |
| --- | --- |
| `default` | Nền tím than, viền kem/lạnh, bóng ngắn. |
| `pressed` | Mặt trong tối hơn, mép dưới giảm độ nổi; giữ nguyên canvas/silhouette. |
| `selected` | Viền vàng rõ và mặt trong ấm hơn; glow nhẹ là lớp bổ sung. |
| `disabled` | Giảm bão hòa và độ nổi, vẫn phân biệt được viền với nền. |
| `attention` | Gắn F07 riêng; không biến cả nút thành đỏ. |

Không cần tạo tất cả trạng thái cho mọi component. Ưu tiên trạng thái cho nút
F06/F09/F14 và ô F16; panel tĩnh chỉ cần biến thể màu đúng vai trò.

## 5. Prompt nền dùng chung

Prompt tiếng Anh để có thể sao chép trực tiếp vào công cụ tạo ảnh. Tài liệu
giải thích bằng tiếng Việt; không yêu cầu ảnh có chữ tiếng Anh hoặc tiếng Việt.
Nếu công cụ hỗ trợ ảnh tham chiếu, đính kèm ảnh gốc để khóa phong cách.

**Ghép theo công thức:** prompt nền + một dòng component ở mục 6 + trạng thái
và tỷ lệ mong muốn + phần loại trừ. Mỗi lần chỉ tạo một component hoặc một lớp.

```text
Create one isolated, reusable 2D pixel RPG interface frame asset.
Use the supplied reference only for the UI frame treatment: deep muted
plum surfaces, crisp stepped pixel corners, layered dark outer outlines,
warm cream or cool lavender edge highlights, and restrained golden accents.
Front-facing orthographic UI, consistent pixel density, upper-left highlights,
short lower-right shadows, subtle pixel bevels, quiet flat interior surfaces.
Keep the frame generic and content-independent. All content areas are empty.
No text, numbers, symbols, icons, portraits or scenery baked into the frame.
Center the complete asset with a small transparent safety margin around it.
Export with a real transparent alpha background, never a checkerboard image.
Keep structural pixel edges crisp; any requested glow is a separate overlay.
```

Phần loại trừ dùng chung (đưa vào negative prompt nếu công cụ có trường riêng):

```text
No complete game screen, UI mockup presentation, device frame, environment,
room, furniture, landscape, map artwork, characters, creatures, pets, portraits,
items, decorative content icons, letters, words, numbers, logo or watermark.
No perspective, isometric view, photorealism, 3D render, glossy mobile-app
buttons, smooth vector corners, heavy texture, noisy dithering, blurry borders,
opaque background outside the asset, baked checkerboard or cropped edges.
```

## 6. Prompt riêng cho từng component

Tỷ lệ sau là điểm bắt đầu để generate, không phải bố cục màn hình cố định.
Phần “empty” của panel vẫn có mặt nền; chỉ vùng ghi “transparent opening” mới
phải rỗng alpha. Không yêu cầu công cụ vẽ tên mã F01… lên ảnh.

| Mã | Tỷ lệ gợi ý | Đoạn prompt thêm vào prompt nền |
| --- | --- | --- |
| F01 | 4:1 | `A wide profile HUD backplate with a dark plum filled surface, cool lavender double rim, stepped lower corners and a chamfered right end. Uninterrupted empty interior; no avatar cutout.` |
| F02 | 1:1 | `A nearly circular portrait ring built from crisp pixel steps, with pale blue and cream highlights and a dark outer edge. The entire central opening is transparent; no portrait or inner background.` |
| F03 | 5:1 | `A slim horizontal pixel capsule counter tray, dark plum filled center, thin cool rim, subtly raised edge, empty uninterrupted face with space for later content.` |
| F04 track | 8:1 | `An empty horizontal progress-bar track with a cream pixel rim, dark recessed interior and stepped end caps. No fill, label, ticks or numbers.` |
| F04 fill | 8:1 | `Only a full-length cyan pixel progress fill strip, brighter along its top edge, flat consistent body suitable for clipping. No enclosing frame or text. Transparent outside the strip.` |
| F05 thân | 3:1 | `A dark plum quest-panel body with stepped corners, restrained warm gold rim and tiny geometric corner accents. Plain empty interior. No attached title tab, divider, icons or text; the title tab will be composed separately.` |
| F05 tab | 3:1 | `A low raised folder-style title tab with a dark plum face, warm gold stepped rim and a chamfered right shoulder. It must attach cleanly to the upper edge of a separate matching panel. Empty face.` |
| F05 divider | 12:1 | `A single thin horizontal pixel divider in muted warm gold, with simple clean ends, transparent around the line. No panel, tab, text or ornament.` |
| F06 | 1:1 | `A compact square utility-button base with stepped chamfered corners, a dark plum face, subtle lavender rim and short lower bevel. Empty center.` |
| F07 | 1:1 | `A small red circular notification badge made with stepped pixel edges, a thin cream rim and dark outer outline. Solid blank red center; no punctuation or number.` |
| F08 cửa sổ | 3:2 | `A rectangular viewport border with stepped corners, a cream inner rim and dark plum outer edge. The entire viewing opening is transparent. No header, map, image or corner button.` |
| F08 header | 6:1 | `A horizontal dark plum viewport header strip with cream top and side rims and stepped upper corners. Straight lower joining edge, blank filled interior, no title or icon.` |
| F09 | 1:1 | `A round pixel utility-button base with a dark plum filled center, cream rim and subtle lower-right bevel. Blank face; no magnifier or symbol.` |
| F10 | 4:3 | `A small cream speech-bubble shell with a dark stepped pixel outline and one short downward tail. Blank opaque cream interior; no dots or text.` |
| F11 | 5:1 | `A narrow context-label plaque with a muted dark brown filled face, thin cream pixel border and chamfered stepped ends. Blank interior; no hand, rays or text.` |
| F12 | 5:1 | `A wide dialogue-panel body with a pale warm cream filled surface, dark plum layered outline, stepped clipped corners and a short shadow. A complete rectangular body with no portrait recess, name tab, arrow or content.` |
| F13 | 3:1 | `A small dark plum speaker-name tab with a cream pixel rim, stepped upper corners and a flat lower joining edge. Blank filled face; no portrait or name.` |
| F14 | 2:1 | `A wide action-button base with a dark warm plum face, cream layered pixel rim, stepped corners and a short lower bevel. Large quiet empty center, no icon or label.` |
| F15 | 6:1 | `A long bottom-navigation backplate with a dark plum filled surface, cool lavender and pale blue layered pixel rim, stepped corners and a subtle bottom shadow. One uninterrupted empty area, no slots, separators or selected tile.` |
| F16 | 1:1 | `A selected navigation-tile plate with a warm golden filled face, bright cream-gold stepped rim and a dark outer edge. No icon, label or glow; transparent outside the tile.` |

Biến thể phụ của F05: thay `warm gold` bằng `muted cyan and cool cream` ở cả
thân, tab và divider; giữ nguyên hình học, độ dày viền và ánh sáng.
F04 fill cần chuẩn hóa kích thước để vừa lòng track, không lấy chiều rộng ngoài
track làm chiều rộng fill. Header F08 phải khớp chiều rộng và mép nối cửa sổ.

Để tạo trạng thái từ một khung đã chọn, dùng chính **ảnh khung đó** làm đầu vào
và thêm một trong các yêu cầu sau, tránh generate lại silhouette tùy ý:

```text
Pressed: preserve the exact canvas, frame silhouette and border thickness.
Darken the face slightly and reduce the lower bevel to suggest depression.

Selected: preserve the exact canvas and geometry. Change the rim to warm
gold and tint the face slightly warmer. Do not add any icon or label.

Disabled: preserve the exact canvas and geometry. Reduce saturation and
bevel contrast while keeping the frame clearly readable.
```

Nếu cần glow: yêu cầu xuất riêng lớp halo vàng mỏng quanh silhouette đã chọn,
cùng canvas, alpha trong suốt, không vẽ lại mặt hoặc viền khung. Đây là ngoại
lệ có chủ ý cho yêu cầu cạnh sắc: halo mềm nhưng khung gốc vẫn sắc.

## 7. Cách ghép để dùng lại về sau

Các công thức dưới đây mô tả quan hệ giữa khung, không xác nhận chức năng đã có.

| Vùng cần dựng | Công thức |
| --- | --- |
| Hồ sơ/tài nguyên | F01 + F02 + F04; các F03 độc lập đặt cạnh nhau. |
| Nhiệm vụ/thông tin | Thân F05 + tab F05 + divider tùy chọn; nội dung là lớp riêng. |
| Xem ảnh/map/preview | F08 cửa sổ + F08 header; F09 là nút nổi tùy chọn. |
| Đối thoại/thông báo | F12 + F13 tùy chọn; chân dung là nội dung có thể thêm sau, không ảnh hưởng thân khung. |
| Tương tác | F11 hoặc F10 + các F14; không cần vòng dưới chân hoặc hình bàn tay. |
| Điều hướng | F15 + F16 theo mục đang chọn + F07 nếu cần thông báo. |

Ở màn hình chính, chỉ HUD và control artwork giữ slot thiết kế. Panel nội
dung dùng chữ dp, xuống dòng và chừa chiều cao tương ứng; không thu nhỏ chữ
để khớp artwork. Khoảng chạm thuộc layout runtime,
có thể rộng hơn artwork. Chữ tiếng Việt dài/ngắn được bố trí riêng, không kéo
giãn bitmap chữ hoặc ép toàn bộ UI thành một ảnh nền cố định.

## 8. Quy trình generate và kiểm tra

1. Tạo thử F14 default và F12 để duyệt hai họ tối/sáng; chọn một mẫu chuẩn.
2. Dùng ảnh mẫu chuẩn đó kèm prompt nền để tạo các component còn lại. Giữ
   palette, hướng sáng và mật độ pixel; không chỉ dựa vào cùng seed.
3. Mỗi output là một component/lớp. Có thể làm contact sheet để so sánh,
   nhưng contact sheet không phải asset bàn giao cuối và không chứa UI thật.
4. Tạo trạng thái cần thiết từ component đã duyệt; canh cùng canvas và silhouette.
5. Kiểm tra alpha, khoảng an toàn, vùng nối và co giãn; chuẩn hóa sau generate
   nếu công cụ chưa cho đúng lưới, độ dày viền hoặc kích thước.
6. Lưu cùng asset: ID, prompt, ảnh tham chiếu, trạng thái, palette, kích thước
   canvas thực, vùng nội dung, lề co giãn và tỷ lệ xuất. Không tự coi ảnh AI là
   asset 9-slice hoàn chỉnh trước khi kiểm tra.

Tên file gợi ý: `ui_<component>_<variant>_<state>.png`, ví dụ
`ui_action_button_dark_default.png`, `ui_quest_body_gold_default.png`,
`ui_dialogue_body_light_default.png`. Các file riêng này chưa được tạo; runtime
hiện dùng `GameSurfaceStyle` với sáu skin màu. Atlas khung được giữ làm
tư liệu gốc, không dùng để vẽ khung runtime.

Checklist duyệt từng output:

- Không còn nhân vật, quái, tranh cảnh, icon nội dung, chữ hay con số.
- Viền/góc còn sắc khi xem ở cỡ sử dụng; không lệch mật độ pixel giữa các khung.
- Alpha thật, không nền caro được vẽ vào ảnh; cửa sổ F02/F08 rỗng đúng vùng.
- Panel/nút có mặt nền đúng màu, không bị rỗng giữa do hiểu sai “empty”.
- Các state không thay đổi kích thước hoặc vị trí khung khi chuyển qua lại.
- Mở rộng panel không làm méo góc, tab, hoa văn và độ dày viền.
- Lòng panel đủ yên để đặt chữ; trạng thái chọn rõ ngay cả khi bỏ glow.
- Không cắt mất bóng/viền; lớp ghép không tạo đường viền đôi ở mép nối.

Kết quả mong muốn là **bộ khung rời, không chứa nội dung**, đủ để dựng nhiều
màn hình cùng phong cách mà không phụ thuộc câu chuyện hoặc nhân vật trong ảnh.

## 9. Quy ước spacing runtime mobile

`GameSpacing` trong `lib/app/presentation/` là nguồn chung cho khoảng cách
artwork của Home và menu. `GameChromeLayout` sở hữu neo HUD/navigation,
`ArtworkProjection` bù scale cho viền/góc của HUD để khớp menu vẽ ở dp. Lưới cơ sở 10 đơn vị
artwork tương đương khoảng 4 dp ở chiều ngắn 390 dp; dùng 1 bước cho khoảng
icon–nhãn và padding nội dung, 2 bước (khoảng 8 dp) cho lề vùng an toàn,
khoảng giữa panel và giữa nút hành động. Không cần bám khoảng cách ảnh gốc.
Viền common được tính riêng, không dùng độ dày viền làm khoảng cách layout.
Các cụm trên được đặt tiếp nhau theo cạnh panel và gap, tránh tọa độ rời rạc.

Footer dùng cùng khoảng 2 bước giữa hội thoại, hành động và điều hướng;
cửa sổ thấp, hẹp không đủ chỗ đặt footer cạnh HUD dùng 1 bước. Các panel vẫn
cùng kích thước khi xoay. Nút compact có icon lớn căn giữa; thẻ nội dung hiện thêm tên qua `showLabel`. Icon trong suốt không viền riêng;
viền kem bo mềm chỉ bao quanh nút; nhãn giữ trong
tooltip/semantics, trạng thái chọn có dấu tick. Nút chữ giữ nhãn căn giữa,
các ô điều hướng có padding và hàng nội dung giống nhau dù đang chọn hay chưa.
Nút tiện ích căn giữa icon cả hai trục; counter và tab nhiệm vụ căn giữa cụm
icon–chữ. Artwork có thể nhỏ hơn vùng chạm; nút thông tin hoạt động vẫn có
vùng chạm ít nhất 48 dp. Không biến các placeholder thành chức năng gameplay.

# Quy chuẩn pixel cho cảnh và spritesheet

## Đơn vị và mẫu tỷ lệ

Một pixel trong PNG xuất cuối bằng **một pixel thế giới**. Nhân vật, quái,
địa hình, vật thể và các lớp nền xuất hiện cùng cảnh dùng chung đơn vị này.
Tại cùng một vị trí trong cảnh, một pixel của thân nhân vật có cùng kích thước
hiển thị với một pixel của cỏ, đá hoặc tường. Vật thể lớn chiếm nhiều pixel hơn.

| Mốc | Kích thước ở lưới gốc |
| --- | --- |
| Nhân vật người tiêu chuẩn | **128 px** từ mặt đất đến đỉnh đầu ở dáng đứng nghỉ. Đo trên hướng tham chiếu, bỏ qua tóc nhô, mũ, vũ khí, bóng đổ và hiệu ứng. |
| Ô khung mặc định của nhân vật chuẩn | **160 × 160 px**, điểm neo chân **(80, 144)**. Gốc tọa độ ở góc trên trái của ô, x sang phải và y xuống dưới. |
| Ô địa hình khi dùng tileset | **32 × 32 px**. Mốc 128 px bằng bốn cạnh ô theo chiều dọc ảnh, dùng để cân mẫu khi vẽ. Kích thước này cũng là bước để mở rộng khung sprite khi cần. |
| Quái, NPC và vật thể | Chọn kích thước theo mẫu so sánh của cảnh. Ví dụ quái nhỏ cao 64 px, nhân vật người cao 128 px và quái lớn cao 192 px. Dáng dài, bè hoặc bay có thể cần ô chữ nhật. |

Đặt các nhân vật, quái và vật thể cần so tỷ lệ trên một ảnh mẫu 1×, với
đường đất chung, nhân vật chuẩn 128 px và một vài mốc như cửa, tảng đá hoặc
thân cây. Đặt cửa và nhân vật sát nhau trước khi duyệt độ rộng, chiều cao và
góc nhìn. Mẫu này cố định camera, hướng sáng, bảng màu và mật độ chi tiết cho
cả bộ asset. Với cảnh khác góc nhìn, dựng mẫu theo góc của cảnh đó và giữ
nguyên đơn vị pixel thế giới.

## Spritesheet nhân vật, quái và vật thể động

- Dùng PNG RGBA trong suốt với cạnh pixel rõ. Xuất từng hành động thành một
  sheet theo mặc định. Mỗi hàng là một hướng được dùng trong game, mỗi cột
  là một frame theo thứ tự thời gian từ trái sang phải. Sheet một hướng có
  một hàng. Ghi rõ thứ tự hướng và số frame hợp lệ theo hàng.
- Khóa kích thước ô và tọa độ neo qua mọi frame, hướng và hành động của
  cùng một chủ thể. Dùng ô mặc định cho nhân vật chuẩn nếu đủ chỗ cho động
  tác. Khi một động tác cần thêm chỗ, mở rộng bằng padding trong suốt theo
  bước 32 px và dùng lại kích thước ô, tọa độ neo mới cho cả bộ của chủ thể.
  Quái và NPC khác cỡ dùng cùng quy ước ô và neo. Giữ nguyên tỷ lệ thân khi
  đưa vào ô. Tránh tự trim hoặc kéo ảnh để từng frame lấp đầy ô.
- Đặt điểm neo tại chỗ tiếp đất của dáng nghỉ. Với sinh vật bay, chọn điểm
  chiếu của nó xuống đất. Khi chạy, nhảy hoặc cúi, vẽ chuyển động quanh neo
  dựa trên cùng bộ tỷ lệ cơ thể. Giữ cả những thay đổi chiều cao thuộc về
  tư thế, đồng thời giữ được vị trí gốc khi phát animation.
- Ghi cùng asset kích thước ô, tọa độ neo trong ô, thứ tự hướng, frame
  hợp lệ, thời lượng từng frame hoặc FPS và kiểu lặp. Ghi thêm kích thước
  dáng nghỉ để đối chiếu. Chỉ thêm metadata runtime khi có tính năng đọc nó.

## Cảnh, tileset và ảnh nền

- Vẽ nền, địa hình, vật thể tiền cảnh và sprite trên cùng lưới gốc, theo
  cùng camera của cảnh. Tách lớp khi cần che khuất chủ thể hoặc chuyển động.
  Nếu có parallax, thay đổi lượng dịch chuyển của lớp và giữ hệ số hiển thị
  pixel chung. Có thể vẽ vật ở xa nhỏ hơn theo phối cảnh của tranh.
- Canh mép tileset vào lưới 32 px. Vật thể lớn có thể chiếm nhiều ô. Với nền
  nguyên tấm, ghi kích thước gốc và mốc tọa độ để đặt sprite đúng mặt đất.
  Mở rộng cảnh bằng cách vẽ thêm vùng ảnh hoặc thêm tile đúng lưới. Chọn vùng
  cắt theo bố cục khi màn hình khác tỷ lệ.
- Áp dụng một phép chiếu cho toàn cảnh. Chọn hệ số nguyên theo **pixel thiết
  bị** khi bố trí viewport, giữ hệ số đó trong lúc chơi và căn gốc vẽ cùng
  các lớp vào lưới pixel thiết bị. Ví dụ ở 2×, mỗi pixel nguồn thành một khối
  2 × 2 pixel thiết bị trên cả sprite lẫn nền. Với Flutter, quy đổi sang
  logical pixel bằng `hệ số nguyên / devicePixelRatio` và lấy mẫu
  nearest-neighbor (`FilterQuality.none`). Khi viewport đổi, tính lại cho
  cả cảnh cùng lúc. Ở màn nhỏ hơn vùng thiết kế tại 1×, dùng vùng nhìn nhỏ
  hơn hoặc cuộn camera. Ở màn rộng, lộ thêm phần cảnh đã vẽ hoặc chừa viền.
- Giữ camera ở tỷ lệ cố định khi đổi nhân vật, phát animation hoặc di
  chuyển. Tránh zoom riêng sprite, `BoxFit.cover` riêng nền và `BoxFit.contain`
  riêng từng chủ thể trong một cảnh. UI, icon, chân dung và ảnh xem thử tuân
  theo [quy chuẩn UI](ui-guidelines.md) khi được hiển thị như nội dung UI.

## Tạo ảnh và duyệt trước khi tích hợp

1. Chốt mẫu 1× và kích thước gốc trước khi generate. Đưa mẫu đã duyệt vào
   làm ảnh tham chiếu cho từng lượt. Trong prompt, mô tả camera, ánh sáng,
   bảng màu, chiều cao dáng nghỉ, neo, kích thước ô, số hướng, số frame và
   thứ tự. Với cảnh, nêu các mốc cần giữ tỷ lệ và vùng cần chừa để đặt sprite.
2. Xem ảnh generate như bản nháp. Có thể dựng lại lưới từ ảnh phóng theo bội
   nguyên khi các khối pixel thật sự đều và đã canh lưới. Dựng sheet cuối ở
   kích thước gốc, canh neo và lưới ở mức pixel. Nếu bản nháp lệch camera,
   tỷ lệ, mật độ điểm ảnh hoặc có cạnh mờ, vẽ lại vùng sai hoặc tạo lại asset
   theo mẫu. Thay `width`, `height` hay thêm zoom lúc render sẽ làm lệch
   đơn vị pixel giữa các lớp.
3. Kiểm tra kích thước PNG, alpha, kích thước ô và frame tràn ô. Chồng các
   frame cùng neo và xem animation để phát hiện chân trượt, thân đổi cỡ hoặc
   hình bị cắt. Ghép sprite thật với nền ở 1×, đối chiếu mốc 128 px và cửa/cây
   với mẫu. Khi tích hợp, kiểm tra viewport hẹp, ngang và rộng trên Android
   và web, bảo đảm mỗi pixel có cùng cỡ trong cảnh, chuyển động có mép rõ và
   thay đổi viewport giữ đúng tỷ lệ giữa các lớp.

## Ảnh xem thử hiện có

Các PNG quái 128 × 128 trong `assets/sprites/` từng được trim và co riêng
trước khi đặt lại vào ô. Ví dụ vùng alpha của slime cao 103 px và golem cao
101 px. Con số 128 ở đây là kích thước ô ảnh xem thử. Đấu trường hiện đặt hai
sprite vào ô 96 và 104 logical pixel, còn nền tự co theo viewport. Home cũng
đang dùng tranh nền phủ màn hình và chân dung vẽ bằng code. Khi dùng các thiết
kế cũ trong cảnh theo chuẩn mới, đối chiếu với mẫu 1×, vẽ lại phần lệch tỷ lệ
hoặc mật độ pixel và đưa cả cảnh lên cùng phép chiếu.

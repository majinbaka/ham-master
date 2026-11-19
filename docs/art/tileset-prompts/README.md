# Prompt tạo tileset làng ven suối

Khi dùng prompt này để tạo tileset, giao việc cho agent **GPT-6.2 Astra**
(`gpt-6.2-astra`) với mức suy luận **`medium`**.

Đính kèm hai ảnh tham khảo khi gửi prompt. Dùng ảnh làng để tham khảo cách
ghép bờ đá, cầu gỗ, nhà và đường mòn. Dùng ảnh mẫu cây để tham khảo cách
dựng tán từ các mảng sáng tối, tạo biến thể và nối mép cụm lá. Đính kèm
[làng ban ngày](../../../assets/scenes/daylight-village.png) để giữ bảng màu
PixelRPG và [Kai trong cảnh ở 1×](../character-previews/kai-village-1x.png)
để đối chiếu tỷ lệ nhân vật. Dùng [mẫu map chiến đấu](../battle-map-prompts/README.md)
để đối chiếu góc nhìn ¾, ánh sáng và mật độ pixel. Kích thước gốc tuân theo
[quy chuẩn pixel thế giới](../world-pixel-grid.md).

Thay ba dòng trong ngoặc vuông để tạo biến thể. Dùng cùng mẫu 1× đã duyệt
cho từng lượt tạo atlas.

```text
Tạo tileset pixel art nguyên bản cho PixelRPG để ghép nhiều bản đồ làng
ven rừng. Từ ảnh làng tham khảo, lấy cách tổ chức cỏ, đường mòn, bờ đá,
suối và cầu. Từ ảnh mẫu cây, lấy cách dựng khối tán, dùng cụm lá và tạo
biến thể sáng tối. Thiết kế hình dáng nhà, tán cây và họa tiết riêng.

Bối cảnh: [ĐỊA HÌNH VÀ LOẠI KHU DÂN CƯ]
Nhóm atlas của lượt này: [MẶT ĐẤT / BỜ ĐÁ VÀ NƯỚC / THẢM THỰC VẬT / CÔNG TRÌNH]
Ánh sáng và bảng màu: [THỜI ĐIỂM TRONG NGÀY VÀ MÀU CHỦ ĐẠO]

Giữ camera cố định từ trên cao chếch ¾, với mép ô địa hình song song với
hai trục ảnh. Dùng cùng góc nhìn cho mặt đất, bờ đá, cầu, nhà và cây.
Ánh sáng dịu từ trên trái. Dùng các cụm pixel rõ cạnh, ít sắc độ mỗi chất
liệu và chừa mảng cỏ, đất phẳng ít tương phản để sprite dễ đọc.

Một pixel trong PNG xuất cuối bằng một pixel thế giới. Lưới địa hình
32 × 32 px. Nhân vật người chuẩn cao 128 px từ mặt đất đến đỉnh đầu ở dáng
đứng nghỉ, bỏ qua tóc nhô, mũ, phụ kiện và bóng đổ. Chiều cao đó bằng bốn
cạnh ô theo chiều dọc ảnh. Khi dùng khung nhân vật mặc định 160 × 160 px,
điểm neo chân là (80, 144), tính từ góc trên trái khung. Dựng mẫu kiểm tỷ lệ
1× với nhân vật đặt sát cửa, thân cây và tảng đá trên cùng đường đất. Kiểm
tra nhân vật lọt lòng cửa và mặt cầu đủ rộng để đi qua. Nhà, cầu và cây lớn
có thể trải qua nhiều ô 32 px. Canh khung vật thể vào lưới và ghi điểm tiếp
đất để đặt chúng đúng vị trí trong cảnh. Giữ nguyên kích thước pixel khi
chuyển từ mẫu 1× sang atlas. Tách ảnh kiểm tỷ lệ khỏi atlas.

Chỉ xuất các mảnh thuộc nhóm đã chọn trong lượt này:
- Mặt đất: cỏ nền lặp được, biến thể cỏ thưa chi tiết, đất đường mòn,
  mép chuyển cỏ–đất theo bốn phía, góc lồi và góc lõm cho mỗi phía.
- Bờ đá và nước: nước nền lặp được, mép nước và bờ đá thẳng bốn hướng,
  góc lồi, góc lõm ở cả bốn góc, mảnh nối đầu bờ với cầu hoặc bậc lên bờ.
  Giữ mặt nước và cao độ chân bờ nhất quán khi ghép đoạn thẳng với góc.
- Thảm thực vật: bụi thấp, cây lá rộng, cây lá kim, hoa và cỏ điểm xuyết.
  Với mảng lá dày, có ô giữa, mép và góc ghép liền. Với cây đứng riêng,
  giữ hướng sáng qua các biến thể và tách tán che nhân vật khỏi thân cây
  khi cần xếp lớp.
- Công trình: nhà gỗ tường kem, cầu ván có đầu cầu và nhịp giữa, bậc gỗ
  nối hai cao độ, biển gỗ trống. Tách sàn cầu và lan can khi cần để sprite
  đi trên sàn và khuất sau lan can tiền cảnh.

Với tile ghép, các cạnh cùng loại phải khớp ở đúng hàng hoặc cột pixel.
Kiểm tra lặp ô nền trong mảng 3 × 3, ghép các góc lồi và lõm với mép thẳng,
rồi thử một đoạn bờ có cầu để phát hiện đường ráp, khe hở và lệch cao độ.

Xuất PNG RGBA ở 1× với chiều rộng, chiều cao là bội của 32 px. Canh atlas
từ góc trên trái, không chèn khe giữa các ô. Ô nền kín toàn bộ 32 × 32 px.
Ô trống và vùng ngoài vật thể hoặc lớp phủ dùng alpha trong suốt thật.
Giữ khung nhiều ô cho vật thể lớn. Ghi sơ đồ ô và điểm neo ngoài PNG.
Không vẽ đường lưới, nhãn, chữ, giao diện, watermark, nhân vật hay quái
trong atlas. Tránh khử răng cưa, làm mờ và nội suy khi xuất ảnh.
```

## Thông số mẫu làng ven suối

- Bối cảnh là làng rừng ban ngày, có đường mòn qua bãi cỏ, bờ đá thấp và
  cầu ván nối hai bờ suối.
- Dựng nhóm mặt đất trước để khóa tỷ lệ và điểm nối cỏ–đất. Giữ cùng camera,
  lưới và ánh sáng khi dựng bờ nước, cây và công trình.
- Dùng cỏ xanh xuân, bóng lá xanh lam lục, đất vàng ấm, đá xanh xám và
  nước xanh ngọc. Nhà có tường kem, mái đất nung dịu hoặc xanh teal nhạt.

Trước khi dùng trong game, kiểm PNG ở 1× và ghép một cảnh nhỏ có đường
mòn, bờ nước, cầu, nhà, cây và sprite thật. Đo lại tỷ lệ cửa với nhân vật,
kiểm các mép ráp và lớp che tiền cảnh. Vẽ lại vùng sai lưới hoặc sai tỷ lệ
trên PNG gốc trước khi tích hợp.

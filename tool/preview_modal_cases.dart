/// Each path taps real controls on a fresh preview of the owning screen.
const previewModalCases = <String, Map<String, List<String>>>{
  'home': {
    'mail': ['Hộp thư'],
    'information': ['Thông tin màn hình'],
  },
  'shop': {
    'starter-pack': ['Xem gói mẫu'],
    'potion': ['Thuốc hồi phục\n120 ngọc\nXem chi tiết'],
    'ticket': ['Vé hành trình\n90 ngọc\nXem chi tiết'],
    'sword': ['Kiếm tập luyện\n300 vàng\nXem chi tiết'],
    'light-stone': ['Đá ánh sáng\n160 ngọc\nXem chi tiết'],
    'supply-bag': ['Túi tiếp tế\n500 vàng\nXem chi tiết'],
    'exploration-book': ['Sổ khám phá\n200 vàng\nXem chi tiết'],
    'collection-pack': ['Gói sưu tầm'],
    'training-pack': ['Gói huấn luyện'],
    'adventure-pack': ['Gói phiêu lưu'],
  },
  'profile': {
    'information': ['Thông tin hồ sơ mẫu'],
    'companion': ['Sổ sưu tầm', 'Bạn đồng hành'],
    'footprints': ['Sổ sưu tầm', 'Dấu chân nhỏ'],
    'guide': ['Sổ sưu tầm', 'Người dẫn đường'],
    'new-page': ['Sổ sưu tầm', 'Trang sách mới'],
    'first-step': ['Huy hiệu', 'Bước chân đầu'],
    'explorer': ['Huy hiệu', 'Người khám phá'],
  },
  'settings': {
    'about': ['Thông tin', 'Giới thiệu PixelRPG'],
    'reset': ['Chung', 'Khôi phục mặc định'],
  },
};

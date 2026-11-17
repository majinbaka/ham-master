import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';

/// Local widget selections demonstrate controls; no device or save settings.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.onNavigate, super.key});
  final ValueChanged<String> onNavigate;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _category = 'Chung';
  final _volumes = <String, double>{
    'Nhạc nền': 80,
    'Hiệu ứng âm thanh': 80,
    'Lồng tiếng': 70,
  };
  final _toggles = <String, bool>{
    'Hiệu ứng hình ảnh': true,
    'Hiện vùng tương tác': true,
    'Bỏ qua hội thoại đã xem': false,
    'Xác nhận vật phẩm quan trọng': true,
  };
  var _quality = 'Cao';
  var _controls = 'Chạm';

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Cài đặt',
    selected: 'settings',
    onNavigate: widget.onNavigate,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Expanded(
          flex: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 6,
            children: [
              for (final category in [
                'Chung',
                'Điều khiển',
                'Âm thanh',
                'Đồ họa',
                'Ngôn ngữ',
                'Tài khoản',
                'Thông tin',
              ])
                MenuButton(
                  label: category,
                  selected: category == _category,
                  onPressed: () => setState(() => _category = category),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 70,
          child: MenuPanel(title: _category, child: _content(context)),
        ),
      ],
    ),
  );

  Widget _content(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 12,
    children: [
      if (_category == 'Chung' || _category == 'Âm thanh') ...[
        const Text('Âm thanh · Điều chỉnh thử, chưa phát âm thanh'),
        for (final entry in _volumes.entries) ...[
          Text('${entry.key}: ${entry.value.round()}%'),
          Slider(
            semanticFormatterCallback: (value) => '${value.round()} phần trăm',
            value: entry.value,
            min: 0,
            max: 100,
            divisions: 10,
            label: '${entry.value.round()}%',
            onChanged: (value) => setState(() => _volumes[entry.key] = value),
          ),
        ],
      ],
      if (_category == 'Chung' || _category == 'Đồ họa') ...[
        const Text('Chất lượng đồ họa · Lựa chọn mẫu'),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final quality in ['Thấp', 'Vừa', 'Cao'])
              MenuButton(
                label: quality,
                selected: quality == _quality,
                onPressed: () => setState(() => _quality = quality),
              ),
          ],
        ),
        _toggle('Hiệu ứng hình ảnh'),
      ],
      if (_category == 'Chung' || _category == 'Điều khiển') ...[
        const Text('Kiểu di chuyển · Lựa chọn mẫu'),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final controls in ['Chạm', 'D-Pad'])
              MenuButton(
                label: controls,
                selected: controls == _controls,
                onPressed: () => setState(() => _controls = controls),
              ),
          ],
        ),
        _toggle('Hiện vùng tương tác'),
        _toggle('Bỏ qua hội thoại đã xem'),
        _toggle('Xác nhận vật phẩm quan trọng'),
      ],
      if (_category == 'Ngôn ngữ')
        const Text(
          'Tiếng Việt\nBản dựng hiện dùng tiếng Việt; chưa có bản dịch khác.',
        ),
      if (_category == 'Tài khoản')
        const Text(
          'Chế độ xem trước offline. Chưa có tài khoản, đăng nhập hoặc mã quà.',
        ),
      if (_category == 'Thông tin') ...[
        const Text(
          'PixelRPG · Bản giao diện mẫu\nAndroid và web\nChưa có gameplay, lưu dữ liệu hoặc âm thanh.',
        ),
        MenuButton(
          label: 'Về Hồ sơ',
          onPressed: () => widget.onNavigate('profile'),
        ),
      ],
    ],
  );

  Widget _toggle(String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      Semantics(
        label: label,
        child: Switch(
          value: _toggles[label]!,
          onChanged: (value) => setState(() => _toggles[label] = value),
        ),
      ),
    ],
  );
}

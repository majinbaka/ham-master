import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import '../../../app/theme/game_typography.dart';
import '../../../app/theme/pixel_ui_colors.dart';

/// Local widget selections demonstrate controls; no device or save settings.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.onNavigate, super.key});
  final ValueChanged<String> onNavigate;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _categories = ['Tài khoản', 'Chung', 'Thông tin'];

  var _category = _categories.first;
  static const _defaultVolumes = <String, double>{
    'Nhạc nền': 80,
    'Hiệu ứng âm thanh': 80,
    'Lồng tiếng': 70,
  };
  static const _defaultToggles = <String, bool>{
    'Hiệu ứng hình ảnh': true,
    'Hiện vùng tương tác': true,
    'Bỏ qua hội thoại đã xem': false,
    'Xác nhận vật phẩm quan trọng': true,
  };
  static const _defaultQuality = 'Cao';
  static const _defaultControls = 'Chạm';

  final _volumes = {..._defaultVolumes};
  final _toggles = {..._defaultToggles};
  var _quality = _defaultQuality;
  var _controls = _defaultControls;

  @override
  Widget build(BuildContext context) => MenuShell(
    title: 'Cài đặt',
    selected: 'settings',
    onNavigate: widget.onNavigate,
    child: MenuColumns(
      leading: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final category in _categories)
            MenuButton.tab(
              label: category,
              selected: category == _category,
              onPressed: () => setState(() => _category = category),
            ),
        ],
      ),
      detail: MenuPanel(title: _category, child: _content(context)),
    ),
  );

  Widget _content(BuildContext context) => switch (_category) {
    'Tài khoản' => const Text(
      'Chế độ xem trước offline. Chưa có tài khoản, đăng nhập hoặc mã quà.',
    ),
    'Chung' => _generalSettings(context),
    _ => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        const Text('PixelRPG · Bản giao diện mẫu'),
        MenuButton(
          label: 'Giới thiệu PixelRPG',
          onPressed: () => showSampleDetail(
            context,
            'Giới thiệu PixelRPG',
            'Bản xem trước giao diện dành cho Android và web. Khung cảnh và nội dung hành trình là dữ liệu minh họa.',
            icon: PixelIconKind.info,
          ),
        ),
        MenuButton(
          label: 'Về Hồ sơ',
          onPressed: () => widget.onNavigate('profile'),
        ),
      ],
    ),
  };

  Widget _generalSettings(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 12,
    children: [
      const Text('Âm thanh · Điều chỉnh thử, chưa phát âm thanh'),
      for (final entry in _volumes.entries) ...[
        Row(
          spacing: 8,
          children: [
            Expanded(child: Text(entry.key)),
            Text(
              '${entry.value.round()}%',
              style: GameTypography.value.copyWith(color: PixelUiColors.amber),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: PixelUiColors.gold,
            inactiveTrackColor: PixelUiColors.teal,
            thumbColor: PixelUiColors.amber,
          ),
          child: Slider(
            semanticFormatterCallback: (value) => '${value.round()} phần trăm',
            value: entry.value,
            min: 0,
            max: 100,
            divisions: 10,
            label: '${entry.value.round()}%',
            onChanged: (value) => setState(() => _volumes[entry.key] = value),
          ),
        ),
      ],
      const Text('Chất lượng đồ họa · Lựa chọn mẫu'),
      Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final quality in ['Thấp', 'Vừa', 'Cao'])
            MenuButton.tab(
              label: quality,
              selected: quality == _quality,
              onPressed: () => setState(() => _quality = quality),
            ),
        ],
      ),
      _toggle('Hiệu ứng hình ảnh'),
      const Text('Kiểu di chuyển · Lựa chọn mẫu'),
      Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final controls in ['Chạm', 'D-Pad'])
            MenuButton.tab(
              label: controls,
              selected: controls == _controls,
              onPressed: () => setState(() => _controls = controls),
            ),
        ],
      ),
      _toggle('Hiện vùng tương tác'),
      _toggle('Bỏ qua hội thoại đã xem'),
      _toggle('Xác nhận vật phẩm quan trọng'),
      MenuButton(label: 'Khôi phục mặc định', onPressed: _confirmReset),
    ],
  );

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Khôi phục mặc định?'),
        content: const Text(
          'Âm lượng, đồ họa và điều khiển mẫu sẽ trở về giá trị ban đầu.',
        ),
        actions: [
          MenuButton(
            label: 'Hủy',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          MenuButton(
            label: 'Khôi phục',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() {
      _volumes.addAll(_defaultVolumes);
      _toggles.addAll(_defaultToggles);
      _quality = _defaultQuality;
      _controls = _defaultControls;
    });
  }

  Widget _toggle(String label) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    activeThumbColor: PixelUiColors.gold,
    activeTrackColor: PixelUiColors.teal,
    value: _toggles[label]!,
    onChanged: (value) => setState(() => _toggles[label] = value),
  );
}

import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/pixel/pixel_frame_skin.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import '../../beasts/presentation/beast_preview_data.dart';
import '../domain/profile_card.dart';
import 'profile_card_catalog.dart';

class ProfileCardEditor extends StatefulWidget {
  const ProfileCardEditor({
    required this.card,
    required this.onSave,
    super.key,
  });

  final ProfileCard card;
  final Future<bool> Function(ProfileCard) onSave;

  @override
  State<ProfileCardEditor> createState() => _ProfileCardEditorState();
}

class _ProfileCardEditorState extends State<ProfileCardEditor> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.card.name);
  late var _background = widget.card.background;
  late var _avatar = widget.card.avatar;
  late var _companion =
      profileCompanion(widget.card.companion)?.sprite.name ?? '';
  var _saving = false;
  var _saveFailed = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _saveFailed = false;
    });
    final saved = await widget.onSave(
      ProfileCard(
        friendCode: widget.card.friendCode,
        name: _name.text.trim(),
        title: widget.card.title,
        bio: widget.card.bio,
        background: _background,
        avatar: _avatar,
        companion: _companion.isEmpty ? null : _companion,
        badges: widget.card.badges,
        showStats: widget.card.showStats,
      ),
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _saveFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      title: const Text('Chỉnh sửa thẻ'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              TextFormField(
                controller: _name,
                enabled: !_saving,
                textCapitalization: TextCapitalization.words,
                maxLength: 28,
                decoration: const InputDecoration(labelText: 'Tên hiển thị'),
                validator: (name) => name == null || name.trim().isEmpty
                    ? 'Nhập tên hiển thị.'
                    : null,
              ),
              _choice(
                label: 'Ảnh nền',
                value: _background,
                entries: [
                  for (final option in ProfileBackground.values)
                    (
                      option,
                      option.label,
                      SizedBox(width: 32, height: 24, child: option.artwork),
                    ),
                ],
                onChanged: (choice) => setState(() => _background = choice),
              ),
              _choice(
                label: 'Avatar',
                value: _avatar,
                entries: [
                  for (final option in ProfileAvatar.values)
                    (
                      option,
                      option.label,
                      SizedBox(width: 22, height: 36, child: option.portrait),
                    ),
                ],
                onChanged: (choice) => setState(() => _avatar = choice),
              ),
              _choice(
                label: 'Yêu thú đồng hành',
                value: _companion,
                entries: [
                  ('', 'Ẩn yêu thú', const SizedBox(width: 32)),
                  for (final beast in BeastPreview.owned)
                    (beast.sprite.name, beast.name, beast.sprite.artwork(32)),
                ],
                onChanged: (choice) => setState(() => _companion = choice),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (_saveFailed)
          const Text(
            'Chưa lưu được thẻ. Thử lại.',
            style: TextStyle(color: PixelUiColors.coral),
          ),
        MenuButton(
          label: 'Hủy',
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
        ),
        MenuButton(
          label: _saving ? 'Đang lưu…' : 'Lưu thẻ',
          skin: PixelFrameSkin.gold,
          onPressed: _saving ? null : _save,
        ),
      ],
    ),
  );

  Widget _choice<T>({
    required String label,
    required T value,
    required List<(T, String, Widget)> entries,
    required ValueChanged<T> onChanged,
  }) => DropdownButtonFormField<T>(
    initialValue: value,
    decoration: InputDecoration(labelText: label),
    isExpanded: true,
    itemHeight: null,
    items: [
      for (final (id, name, artwork) in entries)
        DropdownMenuItem(
          value: id,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Row(
              spacing: 8,
              children: [
                ExcludeSemantics(child: artwork),
                Expanded(child: Text(name)),
              ],
            ),
          ),
        ),
    ],
    onChanged: _saving
        ? null
        : (choice) {
            if (choice != null) onChanged(choice);
          },
  );
}

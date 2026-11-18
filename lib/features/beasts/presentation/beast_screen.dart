import 'package:flutter/material.dart';

import '../../../app/presentation/menu_components.dart';
import '../../../app/presentation/menu_shell.dart';
import '../../../app/presentation/pixel/pixel_icon.dart';
import 'beast_detail.dart';
import 'beast_preview_data.dart';

class BeastScreen extends StatefulWidget {
  const BeastScreen({
    required this.onNavigate,
    required this.onBattle,
    super.key,
  });

  final ValueChanged<String> onNavigate;
  final VoidCallback onBattle;

  @override
  State<BeastScreen> createState() => _BeastScreenState();
}

class _BeastScreenState extends State<BeastScreen> {
  final _detailKey = GlobalKey();
  final _favorites = <BeastPreview>{};
  var _selected = BeastPreview.fireFox;
  var _collection = false;
  var _showFilters = false;
  var _favoritesOnly = false;
  var _sortByLevel = false;
  BeastElement? _element;

  void _openDetail(BeastPreview beast) {
    setState(() => _selected = beast);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final detail = _detailKey.currentContext;
      if (detail != null) {
        Scrollable.ensureVisible(
          detail,
          duration: MediaQuery.disableAnimationsOf(detail)
              ? Duration.zero
              : const Duration(milliseconds: 200),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = [
      ...BeastPreview.owned,
      if (_collection) BeastPreview.shadowWolf,
    ];
    final visible = entries.where((beast) {
      return (_element == null || _element == beast.element) &&
          (!_favoritesOnly || _favorites.contains(beast));
    }).toList();
    if (_sortByLevel) {
      visible.sort((a, b) {
        final byLevel = b.level.compareTo(a.level);
        return byLevel == 0 ? a.name.compareTo(b.name) : byLevel;
      });
    }
    final index = visible.indexOf(_selected);
    final current = index < 0 ? 0 : index;
    final selected = visible.isEmpty ? null : visible[current];
    final canBrowse = visible.length > 1;

    return MenuShell(
      title: 'Yêu thú',
      selected: 'profile',
      onNavigate: widget.onNavigate,
      onBack: () => widget.onNavigate('profile'),
      backLabel: 'Về Hồ sơ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              MenuButton.tab(
                label: 'Danh sách',
                selected: !_collection,
                onPressed: () => setState(() => _collection = false),
              ),
              MenuButton.tab(
                label: 'Bộ sưu tầm',
                selected: _collection,
                onPressed: () => setState(() => _collection = true),
              ),
              MenuButton.tab(
                label: 'Bộ lọc',
                selected: _showFilters,
                onPressed: () => setState(() => _showFilters = !_showFilters),
              ),
              MenuButton.tab(
                label: _sortByLevel ? 'Cấp cao trước' : 'Sắp xếp',
                selected: _sortByLevel,
                onPressed: () => setState(() => _sortByLevel = !_sortByLevel),
              ),
            ],
          ),
          if (_showFilters)
            MenuPanel(
              light: true,
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  MenuButton.tab(
                    label: 'Chỉ yêu thích',
                    selected: _favoritesOnly,
                    onPressed: () =>
                        setState(() => _favoritesOnly = !_favoritesOnly),
                  ),
                  for (final element in [null, ...BeastElement.values])
                    MenuButton.tab(
                      label: element?.label ?? 'Mọi hệ',
                      selected: _element == element,
                      onPressed: () => setState(() => _element = element),
                    ),
                ],
              ),
            ),
          MenuColumns(
            leading: MenuPanel(
              title: _collection
                  ? '${entries.length} loài đã gặp'
                  : '${entries.length} / 120 yêu thú',
              child: visible.isEmpty
                  ? const Text('Không tìm thấy yêu thú phù hợp.')
                  : MenuGrid(
                      minItemWidth: 80,
                      maxColumns: 3,
                      children: [
                        for (final beast in visible)
                          MenuButton(
                            label: '${beast.name}\nCấp ${beast.level}',
                            artwork: beast.sprite.artwork(48),
                            selected: beast == selected,
                            showLabel: true,
                            onPressed: () => _openDetail(beast),
                          ),
                      ],
                    ),
            ),
            detail: selected == null
                ? const SizedBox.shrink()
                : BeastDetail(
                    key: _detailKey,
                    beast: selected,
                    favorite: _favorites.contains(selected),
                    onFavorite: () => setState(() {
                      if (!_favorites.remove(selected)) {
                        _favorites.add(selected);
                      }
                    }),
                    onPrevious: canBrowse
                        ? () => setState(
                            () => _selected =
                                visible[(current - 1) % visible.length],
                          )
                        : null,
                    onNext: canBrowse
                        ? () => setState(
                            () => _selected =
                                visible[(current + 1) % visible.length],
                          )
                        : null,
                    onBattle: widget.onBattle,
                  ),
          ),
          MenuPanel(
            title: 'Chăm sóc yêu thú',
            child: MenuGrid(
              minItemWidth: 96,
              maxColumns: 3,
              children: [
                for (final (label, icon, description) in const [
                  (
                    'Đội hình',
                    PixelIconKind.beasts,
                    'Hỏa Hổ là bạn đồng hành trong trận chiến mẫu.',
                  ),
                  (
                    'Nuôi dưỡng',
                    PixelIconKind.backpack,
                    'Thức ăn là vật phẩm minh họa dùng để chăm sóc yêu thú.',
                  ),
                  (
                    'Tiến hóa',
                    PixelIconKind.energy,
                    'Tiến hóa là bản xem trước cho các hình dạng mới của yêu thú.',
                  ),
                ])
                  MenuButton(
                    label: label,
                    icon: icon,
                    showLabel: true,
                    onPressed: () => showSampleDetail(
                      context,
                      label,
                      description,
                      icon: icon,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../../app/presentation/pixel/pixel_icon.dart';
import '../../../app/presentation/traveler_portrait.dart';
import '../../../app/theme/pixel_ui_colors.dart';
import '../../beasts/presentation/beast_preview_data.dart';
import '../domain/profile_card.dart';

extension ProfileBackgroundArtwork on ProfileBackground {
  String get label => switch (this) {
    ProfileBackground.village => 'Làng ban ngày',
    ProfileBackground.forest => 'Rừng đấu trường',
    ProfileBackground.parchment => 'Giấy cổ',
  };

  Widget get artwork => switch (this) {
    ProfileBackground.village => _scene('daylight-village'),
    ProfileBackground.forest => _scene('forest-arena'),
    ProfileBackground.parchment => const ColoredBox(color: PixelUiColors.gold),
  };

  Widget _scene(String name) => Image.asset(
    'assets/scenes/$name.png',
    fit: BoxFit.cover,
    alignment: Alignment.center,
    filterQuality: FilterQuality.none,
    excludeFromSemantics: true,
  );
}

extension ProfileAvatarArtwork on ProfileAvatar {
  String get label => switch (this) {
    ProfileAvatar.traveler => 'Lữ hành mũ vàng',
    ProfileAvatar.ranger => 'Kiểm lâm',
    ProfileAvatar.scout => 'Trinh sát',
  };

  TravelerPortrait get portrait => switch (this) {
    ProfileAvatar.traveler => const TravelerPortrait(),
    ProfileAvatar.ranger => const TravelerPortrait(
      hat: PixelUiColors.mint,
      coat: PixelUiColors.teal,
      trim: PixelUiColors.outline,
    ),
    ProfileAvatar.scout => const TravelerPortrait(
      hat: PixelUiColors.peach,
      coat: PixelUiColors.coral,
      trim: PixelUiColors.amber,
    ),
  };
}

extension ProfileBadgeArtwork on ProfileBadge {
  String get label => switch (this) {
    ProfileBadge.firstStep => 'Bước chân đầu',
    ProfileBadge.explorer => 'Người khám phá',
  };

  PixelIconKind get icon => switch (this) {
    ProfileBadge.firstStep => PixelIconKind.coin,
    ProfileBadge.explorer => PixelIconKind.compass,
  };

  String get description => switch (this) {
    ProfileBadge.firstStep =>
      'Huy hiệu dành cho nhà lữ hành lần đầu ghé thăm làng.',
    ProfileBadge.explorer =>
      'Huy hiệu minh họa cho việc ghé thăm các địa điểm trong làng.',
  };
}

BeastPreview? profileCompanion(String? id) {
  for (final beast in BeastPreview.owned) {
    if (beast.sprite.name == id) return beast;
  }
  return null;
}

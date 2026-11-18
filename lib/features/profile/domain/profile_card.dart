enum ProfileBackground { village, forest, parchment }

enum ProfileAvatar { traveler, ranger, scout }

enum ProfileBadge { firstStep, explorer }

/// Local presentation preferences and the public code printed on the card.
class ProfileCard {
  ProfileCard({
    required this.friendCode,
    this.name = 'Nhà lữ hành',
    this.title = 'Nhà sưu tầm',
    this.bio = 'Một hành trình mới bắt đầu!',
    this.background = ProfileBackground.village,
    this.avatar = ProfileAvatar.traveler,
    this.companion = 'fireFox',
    Set<ProfileBadge> badges = const {ProfileBadge.firstStep},
    this.showStats = true,
  }) : badges = Set.unmodifiable(badges);

  final String friendCode;
  final String name;
  final String title;
  final String bio;
  final ProfileBackground background;
  final ProfileAvatar avatar;
  final String? companion;
  final Set<ProfileBadge> badges;
  final bool showStats;
}

import '../../../app/presentation/battle_move.dart';
import '../../../app/presentation/beast_sprite.dart';

enum BeastElement {
  fire('Hỏa'),
  water('Thủy'),
  leaf('Mộc'),
  wind('Phong'),
  shadow('Bóng tối'),
  earth('Thổ'),
  lightning('Lôi'),
  light('Ánh sáng');

  const BeastElement(this.label);
  final String label;
}

class BeastPreview {
  const BeastPreview(
    this.name,
    this.sprite,
    this.element,
    this.level,
    this.stars,
    this.role,
    this.stats, {
    this.moves = const [],
  });

  final String name;
  final BeastSprite sprite;
  final BeastElement element;
  final int level;
  final int stars;
  final String role;
  final (int hp, int attack, int defense, int speed) stats;
  final List<BattleMove> moves;

  String get starsLabel => List.filled(stars, '★').join();

  static const fireFox = BeastPreview(
    'Hỏa Hổ',
    BeastSprite.fireFox,
    BeastElement.fire,
    12,
    3,
    'Tấn công',
    (38, 26, 18, 24),
    moves: BattleMove.values,
  );

  static const owned = [
    fireFox,
    BeastPreview(
      'Hồ Băng',
      BeastSprite.frostFox,
      BeastElement.water,
      10,
      2,
      'Tấn công',
      (33, 21, 15, 22),
    ),
    BeastPreview(
      'Thỏ Mầm',
      BeastSprite.leafHare,
      BeastElement.leaf,
      8,
      2,
      'Hỗ trợ',
      (27, 13, 16, 20),
    ),
    BeastPreview('Cú Nâu', BeastSprite.owl, BeastElement.wind, 9, 2, 'Hỗ trợ', (
      31,
      15,
      17,
      24,
    )),
    BeastPreview(
      'Dơi Tím',
      BeastSprite.bat,
      BeastElement.shadow,
      7,
      2,
      'Tấn công',
      (23, 18, 11, 25),
    ),
    BeastPreview(
      'Người Đá',
      BeastSprite.golem,
      BeastElement.earth,
      11,
      3,
      'Phòng thủ',
      (48, 20, 30, 9),
    ),
    BeastPreview(
      'Giọt Lam',
      BeastSprite.slime,
      BeastElement.water,
      5,
      1,
      'Phòng thủ',
      (24, 8, 15, 8),
    ),
    BeastPreview(
      'Nấm Đốm',
      BeastSprite.mushroom,
      BeastElement.leaf,
      6,
      2,
      'Hỗ trợ',
      (26, 10, 14, 10),
    ),
    BeastPreview(
      'Thỏ Sét',
      BeastSprite.sparkHare,
      BeastElement.lightning,
      10,
      3,
      'Tấn công',
      (28, 22, 14, 29),
    ),
    BeastPreview(
      'Thỏ Trắng',
      BeastSprite.whiteRabbit,
      BeastElement.light,
      4,
      1,
      'Hỗ trợ',
      (18, 7, 10, 15),
    ),
    BeastPreview(
      'Lợn Gai',
      BeastSprite.boar,
      BeastElement.fire,
      8,
      2,
      'Tấn công',
      (34, 20, 17, 13),
    ),
    BeastPreview(
      'Chim Lam',
      BeastSprite.blueBird,
      BeastElement.water,
      7,
      2,
      'Hỗ trợ',
      (22, 13, 12, 23),
    ),
  ];

  static const shadowWolf = BeastPreview(
    'Sói Bóng Đêm',
    BeastSprite.shadowWolf,
    BeastElement.shadow,
    14,
    3,
    'Tấn công',
    (52, 29, 20, 25),
  );
}

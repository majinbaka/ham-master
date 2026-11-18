import 'package:flutter/widgets.dart';

enum BeastSprite {
  fireFox('fire-fox'),
  frostFox('frost-fox'),
  leafHare('leaf-hare'),
  owl('owl'),
  bat('bat'),
  golem('golem'),
  slime('slime'),
  mushroom('mushroom'),
  sparkHare('spark-hare'),
  whiteRabbit('white-rabbit'),
  boar('boar'),
  blueBird('blue-bird'),
  shadowWolf('shadow-wolf'),
  fireFoxBack('fire-fox-back');

  const BeastSprite(this._assetName);

  final String _assetName;

  Widget artwork(double size) => Image.asset(
    'assets/sprites/$_assetName.png',
    width: size,
    height: size,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.none,
    excludeFromSemantics: true,
  );
}

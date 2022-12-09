import 'dart:math';

import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samegame/constants/palatte.dart';

@immutable
class TileTexture {
  final PaletteEntry normal;
  final PaletteEntry selected;
  final PaletteEntry flushed;
  final String label;

  const TileTexture._(
    this.normal,
    this.selected,
    this.flushed,
    this.label,
  );

  static const TileTexture red = TileTexture._(
    Palatte.tileRed,
    Palatte.tileRedSelected,
    Palatte.tileFlushed,
    "red",
  );
  static const TileTexture yellow = TileTexture._(
    Palatte.tileYellow,
    Palatte.tileYellowSelected,
    Palatte.tileFlushed,
    "yellow",
  );
  static TileTexture blue = const TileTexture._(
    Palatte.tileBlue,
    Palatte.tileBlueSelected,
    Palatte.tileFlushed,
    "blue",
  );
  static TileTexture green = const TileTexture._(
    Palatte.tileGreen,
    Palatte.tileGreenSelected,
    Palatte.tileFlushed,
    "green",
  );
  static TileTexture purple = const TileTexture._(
    Palatte.tilePurple,
    Palatte.tilePurpleSelected,
    Palatte.tileFlushed,
    "purple",
  );

  static final List<TileTexture> _singletones = [
    red,
    yellow,
    blue,
    green,
    purple,
  ];

  static TileTexture random(int nColors) {
    assert(nColors <= _singletones.length);

    final n = Random().nextInt(nColors);
    return _singletones[n];
  }

  @override
  String toString() {
    return label;
  }

  void renderNormal(Canvas canvas, Rect rect) {
    canvas.drawRect(rect, normal.paint());
  }

  void renderSelected(Canvas canvas, Rect rect) {
    canvas.drawRect(rect, selected.paint());
  }

  void renderFlushed(Canvas canvas, Rect rect) {
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(rect, paint);
  }
}

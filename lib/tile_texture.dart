import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class TileTexture {
  final Color normal;
  final Color selected;
  final String label;

  const TileTexture._(this.normal, this.selected, this.label);

  static TileTexture red = const TileTexture._(
    Colors.red,
    Colors.grey,
    "red",
  );
  static TileTexture yellow = const TileTexture._(
    Colors.yellow,
    Colors.grey,
    "yellow",
  );
  static TileTexture blue = const TileTexture._(
    Colors.blue,
    Colors.grey,
    "blue",
  );

  static final List<TileTexture> _singletones = [
    red,
    yellow,
    blue,
  ];

  static TileTexture random() {
    final n = Random().nextInt(_singletones.length);
    return _singletones[n];
  }

  @override
  String toString() {
    return label;
  }

  void renderNormal(Canvas canvas, Rect rect) {
    final paint = Paint()..color = normal;
    canvas.drawRect(rect, paint);
  }

  void renderSelected(Canvas canvas, Rect rect) {
    final paint = Paint()..color = selected;
    canvas.drawRect(rect, paint);
  }

  void renderFlushed(Canvas canvas, Rect rect) {
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(rect, paint);
  }
}

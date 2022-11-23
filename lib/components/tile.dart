import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samegame/samegame_game.dart';
import 'package:flutter_samegame/tile_color.dart';

enum Status {
  normal,
  selected,
  flushed,
}

class Tile extends PositionComponent
    with TapCallbacks, HasGameRef<SamegameGame> {
  TileColor tileColor;
  final int xPos;
  final int yPos;

  Status status = Status.normal;

  Tile({
    required this.xPos,
    required this.yPos,
    required this.tileColor,
  }) : super(size: SamegameGame.tileSize);

  @override
  void render(Canvas canvas) {
    final Paint paint;
    switch (status) {
      case Status.normal:
        paint = Paint()..color = tileColor.normal;
        break;
      case Status.selected:
        paint = Paint()..color = tileColor.selected;
        break;
      case Status.flushed:
        paint = Paint()..color = Colors.white;
        break;
    }

    canvas.drawRect(
      size.toRect(),
      paint,
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.onTap(this);
  }

  @override
  String toString() {
    return "($xPos, $yPos), $status, $tileColor";
  }

  void select() {
    assert(status == Status.normal, toString());
    status = Status.selected;
  }

  void unselect() {
    assert(status == Status.selected, toString());
    status = Status.normal;
  }

  bool isSelected() {
    return status == Status.selected;
  }

  bool isSameColor(TileColor color) {
    if (isFlushed()) {
      return false;
    }
    return tileColor == color;
  }

  void flush() {
    //debugPrint('flush $xPos, $yPos');
    assert(status == Status.selected, toString());
    status = Status.flushed;
  }

  bool isFlushed() {
    return status == Status.flushed;
  }

  void swap(Tile other) {
    final tmpColor = tileColor;
    tileColor = other.tileColor;
    other.tileColor = tmpColor;

    final tmpStatus = status;
    status = other.status;
    other.status = tmpStatus;
  }
}

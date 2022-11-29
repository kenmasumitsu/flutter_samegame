import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samegame/samegame_game.dart';
import 'package:flutter_samegame/tile_texture.dart';

enum Status {
  normal,
  selected,
  flushed,
}

class Tile extends PositionComponent
    with TapCallbacks, HasGameRef<SamegameGame> {
  static const double tileWidth = 32;
  static const double tileHeight = 32;

  final int xPos;
  final int yPos;
  TileTexture texture;
  Status status = Status.normal;

  Tile({
    required this.xPos,
    required this.yPos,
    required this.texture,
  }) : super(size: Vector2(tileWidth, tileHeight));

  @override
  void render(Canvas canvas) {
    //debugPrint("render $this");
    switch (status) {
      case Status.normal:
        texture.renderNormal(canvas, size.toRect());
        break;
      case Status.selected:
        texture.renderSelected(canvas, size.toRect());
        break;
      case Status.flushed:
        texture.renderFlushed(canvas, size.toRect());
        break;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.onTap(this);
  }

  @override
  String toString() {
    return "($xPos, $yPos), $position, $status, $texture";
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

  bool isSameColor(TileTexture color) {
    if (isFlushed()) {
      return false;
    }
    return texture == color;
  }

  void flush() {
    //debugPrint('flush $xPos, $yPos');
    status = Status.flushed;
  }

  bool isFlushed() {
    return status == Status.flushed;
  }

  void copy(Tile other) {
    status = other.status;
    texture = other.texture;
  }

  // @override
  // bool get debugMode => true;
}

import 'dart:math';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter_samegame/tile_color.dart';

import 'components/tile.dart';

class SamegameGame extends FlameGame with HasTappableComponents {
  static const int yMax = 8;
  static const int xMax = 12;

  static const double tileWidth = 32;
  static const double tileHeight = 32;
  static final Vector2 tileSize = Vector2(tileWidth, tileHeight);

  late final List<List<Tile>> tiles;

  List<Tile> selectedTiles = [];
  int _score = 0;

  @override
  Future<void>? onLoad() {
    super.onLoad();

    tiles = List.generate(yMax, (yIndex) {
      return List.generate(xMax, (xIndex) {
        return Tile(
          xPos: xIndex,
          yPos: yIndex,
          tileColor: TileColor.random(),
        )..position = Vector2(tileWidth * xIndex, tileHeight * yIndex);
      });
    });

    final world = World();
    for (int y = 0; y < tiles.length; y++) {
      for (int x = 0; x < tiles[y].length; x++) {
        world.add(tiles[y][x]);
      }
    }
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize =
          Vector2(tileWidth * xMax, tileHeight * yMax)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    add(camera);

    return null;
  }

  bool isSelected() {
    return selectedTiles.isNotEmpty;
  }

  void _select(Tile tile) {
    assert(!isSelected());

    final List<List<bool>> traverseMap = List.generate(
      yMax,
      (yIndex) => List.generate(
        xMax,
        ((xIdex) => false),
      ),
    );

    _doSelect(
      tile.xPos,
      tile.yPos,
      tile.tileColor,
      traverseMap,
    );

    if (selectedTiles.length == 1) {
      selectedTiles.clear();
    } else if (selectedTiles.length >= 2) {
      for (var tile in selectedTiles) {
        tile.select();
      }
    }
  }

  void _doSelect(
    int xPos,
    int yPos,
    TileColor color,
    List<List<bool>> traverseMap,
  ) {
    if (xPos < 0 || xMax <= xPos) {
      return;
    }
    if (yPos < 0 || yMax <= yPos) {
      return;
    }

    if (traverseMap[yPos][xPos]) {
      return;
    }

    traverseMap[yPos][xPos] = true;
    if (tiles[yPos][xPos].isSameColor(color) == false) {
      return;
    }

    selectedTiles.add(tiles[yPos][xPos]);

    _doSelect(xPos - 1, yPos, color, traverseMap);
    _doSelect(xPos + 1, yPos, color, traverseMap);
    _doSelect(xPos, yPos - 1, color, traverseMap);
    _doSelect(xPos, yPos + 1, color, traverseMap);
  }

  void onTap(Tile tile) {
    switch (tile.status) {
      case Status.normal:
        if (isSelected()) {
          _resetSelected();
        } else {
          _select(tile);
        }
        break;
      case Status.selected:
        flushSelected();
        break;
      case Status.flushed:
        // do nothing
        break;
    }
  }

  void _resetSelected() {
    for (var tile in selectedTiles) {
      tile.unselect();
    }
    selectedTiles.clear();
  }

  void flushSelected() {
    assert(selectedTiles.length >= 2);

    _score += (selectedTiles.length - 2) * (selectedTiles.length - 2);
    for (var tile in selectedTiles) {
      tile.flush();
    }
    selectedTiles.clear();

    _handleColumn();
    _handleRow();
  }

  void _handleColumn() {
    for (var y = 0; y < yMax; y++) {
      for (var x = 0; x < xMax; x++) {
        if (tiles[y][x].isFlushed()) {
          _shiftDown(x, y);
        }
      }
    }
  }

  void _shiftDown(int xPos, int yPos) {
    if (yPos <= 0) {
      return;
    }

    for (var y = yPos - 1; y >= 0; y--) {
      _swapTile(xPos, y + 1, xPos, y);
    }
  }

  void _handleRow() {
    for (var x = xMax - 1; x >= 0; x--) {
      if (_isFlushedColumn(x)) {
        _shiftLeft(x);
      }
    }
  }

  bool _isFlushedColumn(int xPos) {
    assert(0 <= xPos && xPos < xMax);

    for (var y = 0; y < yMax; y++) {
      if (tiles[y][xPos].isFlushed() == false) {
        return false;
      }
    }
    return true;
  }

  void _shiftLeft(int xPos) {
    if (xPos == xMax - 1) {
      return;
    }

    for (var x = xPos + 1; x < xMax; x++) {
      for (var yPos = 0; yPos < yMax; yPos++) {
        _swapTile(x - 1, yPos, x, yPos);
      }
    }
  }

  void _swapTile(int xPos1, int yPos1, int xPos2, int yPos2) {
    //debugPrint('($xPos1, $yPos1) <-> ($xPos2, $yPos2)');

    final tile1 = tiles[yPos1][xPos1];
    final tile2 = tiles[yPos2][xPos2];

    tile1.swap(tile2);
  }
}

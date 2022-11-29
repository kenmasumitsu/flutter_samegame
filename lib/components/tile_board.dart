import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../tile_texture.dart';
import 'tile.dart';

class TileBoard extends PositionComponent {
  final int xMax;
  final int yMax;
  late final List<List<Tile>> _tiles;
  final List<Tile> _selectedTiles = [];

  int _score = 0;

  TileBoard({
    required this.xMax,
    required this.yMax,
  }) : super(size: Vector2(Tile.tileWidth * xMax, Tile.tileHeight * yMax));

  @override
  Future<void>? onLoad() {
    super.onLoad();

    _tiles = List.generate(
      xMax,
      (xIndex) {
        return List.generate(
          yMax,
          (yIndex) {
            final tile = Tile(
              texture: TileTexture.random(),
              xPos: xIndex,
              yPos: yIndex,
            )..position = Vector2(xIndex * Tile.tileWidth,
                (yMax - (yIndex + 1)) * Tile.tileHeight);
            add(tile);
            return tile;
          },
        );
      },
    );
    return null;
  }

  @override
  void render(Canvas canvas) {}

  @override
  bool get debugMode => false;

  void onTap(Tile tile) {
    switch (tile.status) {
      case Status.normal:
        if (_isSelected()) {
          _resetSelected();
        } else {
          _select(tile);
        }
        break;
      case Status.selected:
        _flushSelected();
        break;
      case Status.flushed:
        // do nothing
        break;
    }
  }

  bool _isSelected() {
    return _selectedTiles.isNotEmpty;
  }

  void _resetSelected() {
    for (var tile in _selectedTiles) {
      tile.unselect();
    }
    _selectedTiles.clear();
  }

  void _select(Tile tile) {
    assert(!_isSelected());

    final List<List<bool>> traverseMap = List.generate(
      xMax,
      (xIndex) => List.generate(
        yMax,
        ((yIndex) => false),
      ),
    );

    _doSelect(
      tile.xPos,
      tile.yPos,
      tile.texture,
      traverseMap,
    );

    if (_selectedTiles.length == 1) {
      _selectedTiles.clear();
    } else if (_selectedTiles.length >= 2) {
      for (var tile in _selectedTiles) {
        tile.select();
      }
    }
  }

  void _doSelect(
    int xPos,
    int yPos,
    TileTexture color,
    List<List<bool>> traverseMap,
  ) {
    if (xPos < 0 || xMax <= xPos) {
      return;
    }
    if (yPos < 0 || yMax <= yPos) {
      return;
    }

    if (traverseMap[xPos][yPos]) {
      return;
    }

    traverseMap[xPos][yPos] = true;
    if (_tiles[xPos][yPos].isSameColor(color) == false) {
      return;
    }

    _selectedTiles.add(_tiles[xPos][yPos]);

    _doSelect(xPos - 1, yPos, color, traverseMap);
    _doSelect(xPos + 1, yPos, color, traverseMap);
    _doSelect(xPos, yPos - 1, color, traverseMap);
    _doSelect(xPos, yPos + 1, color, traverseMap);
  }

  void _flushSelected() {
    assert(_selectedTiles.length >= 2);

    _score += (_selectedTiles.length - 2) * (_selectedTiles.length - 2);
    for (var tile in _selectedTiles) {
      tile.flush();
    }

    final xPosSet = _selectedTiles
        .map(
          (tile) => tile.xPos,
        )
        .toSet();
    _selectedTiles.clear();

    _handleColumn(xPosSet);
    _handleRow();
  }

  void _handleColumn(Set<int> xPosSet) {
    for (var xPos in xPosSet) {
      final tiles = _tiles[xPos];

      int toYPos = 0;
      for (var yPos = 0; yPos < tiles.length; yPos++) {
        if (!tiles[yPos].isFlushed()) {
          tiles[toYPos].copy(tiles[yPos]);
          toYPos++;
        }
      }

      while (toYPos < tiles.length) {
        tiles[toYPos].flush();
        toYPos++;
      }
    }
  }

  void _handleRow() {
    int toXPos = 0;
    for (var xPos = 0; xPos < _tiles.length; xPos++) {
      final tiles = _tiles[xPos];
      if (!tiles[0].isFlushed()) {
        _copyRow(xPos, toXPos);
        toXPos++;
      }
    }

    while (toXPos < _tiles.length) {
      _flushRow(toXPos);
      toXPos++;
    }
  }

  void _copyRow(int fromX, int toX) {
    for (int y = 0; y < yMax; y++) {
      _tiles[toX][y].copy(_tiles[fromX][y]);
    }
  }

  void _flushRow(int x) {
    for (int y = 0; y < yMax; y++) {
      _tiles[x][y].flush();
    }
  }
}
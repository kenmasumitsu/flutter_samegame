import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_samegame/flame/samegame_game.dart' as game;

import '../tile_texture.dart';
import 'tile.dart';

class TileBoard extends PositionComponent with HasGameRef<game.SamegameGame> {
  final int nColumns;
  final int nRows;
  final int nColors;
  late final List<List<Tile>> _tiles;
  List<Tile> _selectedTiles = [];

  int _score = 0;
  int get score => _score;
  set score(int v) {
    _score = v;
    gameRef.setScore(_score);
  }

  TileBoard({
    required this.nColumns,
    required this.nRows,
    required this.nColors,
  });

  @override
  Future<void>? onLoad() {
    super.onLoad();

    score = 0;
    final tileSize = _calcTileSize();

    _tiles = List.generate(
      nColumns,
      (xIndex) {
        return List.generate(
          nRows,
          (yIndex) {
            final tile = Tile(
              xPos: xIndex,
              yPos: yIndex,
              nColors: nColors,
            )
              ..position =
                  Vector2(xIndex * tileSize, (nRows - (yIndex + 1)) * tileSize)
              ..size = Vector2(tileSize, tileSize);
            add(tile);
            return tile;
          },
        );
      },
    );
    return null;
  }

  double _calcTileSize() {
    final width = game.SamegameGame.tileBoardWidth / nColumns;
    final height = game.SamegameGame.tileBoardHeight / nRows;
    return max(width, height);
  }

  void reset() {
    score = 0;
    _selectedTiles.clear();
    for (final colTiles in _tiles) {
      for (final tile in colTiles) {
        tile.reset();
      }
    }
  }

  @override
  bool get debugMode => false;

  void onTap(Tile tile) {
    switch (tile.status) {
      case Status.normal:
        if (_isSelected()) {
          _resetSelected();
        } else {
          _selectedTiles = _findSelectedTiles(tile);
          for (final tile in _selectedTiles) {
            tile.select();
          }
        }
        break;
      case Status.selected:
        _flushSelected();

        if (_isGameClear()) {
          // check game clear
          score += 1000;
          gameRef.gameClear();
        } else if (_isGameOver()) {
          // check game over
          gameRef.gameOver();
        }
        break;
      case Status.flushed:
        // do nothing
        break;
    }
  }

  bool _isGameClear() {
    if (_tiles[0][0].isFlushed()) {
      return true;
    }
    return false;
  }

  bool _isGameOver() {
    assert(!_isSelected());
    for (final colTiles in _tiles) {
      for (final tile in colTiles) {
        if (tile.isFlushed()) {
          continue;
        }
        final selectedTiles = _findSelectedTiles(tile);
        if (selectedTiles.isNotEmpty) {
          return false;
        }
      }
    }

    return true;
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

  List<Tile> _findSelectedTiles(Tile tile) {
    assert(!_isSelected());

    final List<Tile> selectedTiles = [];
    final List<List<bool>> traverseMap = List.generate(
      nColumns,
      (xIndex) => List.generate(
        nRows,
        ((yIndex) => false),
      ),
    );

    _doSelect(
      tile.xPos,
      tile.yPos,
      tile.texture,
      traverseMap,
      selectedTiles,
    );

    if (selectedTiles.length > 1) {
      return selectedTiles;
    } else {
      return [];
    }
  }

  void _doSelect(
    int xPos,
    int yPos,
    TileTexture color,
    List<List<bool>> traverseMap,
    List<Tile> selectedTiles,
  ) {
    if (xPos < 0 || nColumns <= xPos) {
      return;
    }
    if (yPos < 0 || nRows <= yPos) {
      return;
    }

    if (traverseMap[xPos][yPos]) {
      return;
    }

    traverseMap[xPos][yPos] = true;
    if (_tiles[xPos][yPos].isSameColor(color) == false) {
      return;
    }

    selectedTiles.add(_tiles[xPos][yPos]);

    _doSelect(xPos - 1, yPos, color, traverseMap, selectedTiles);
    _doSelect(xPos + 1, yPos, color, traverseMap, selectedTiles);
    _doSelect(xPos, yPos - 1, color, traverseMap, selectedTiles);
    _doSelect(xPos, yPos + 1, color, traverseMap, selectedTiles);
  }

  Future<void> _flushSelected() async {
    assert(_selectedTiles.length >= 2);

    score += (_selectedTiles.length - 2) * (_selectedTiles.length - 2);
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

    FlameAudio.play('flush.mp3', volume: 0.3);
  }

  void _handleColumn(Set<int> xPosSet) {
    for (var xPos in xPosSet) {
      final colTiles = _tiles[xPos];

      int toYPos = 0;
      for (var yPos = 0; yPos < colTiles.length; yPos++) {
        if (!colTiles[yPos].isFlushed()) {
          colTiles[toYPos].copy(colTiles[yPos]);
          toYPos++;
        }
      }

      while (toYPos < colTiles.length) {
        colTiles[toYPos].flush();
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
    for (int y = 0; y < nRows; y++) {
      _tiles[toX][y].copy(_tiles[fromX][y]);
    }
  }

  void _flushRow(int x) {
    for (int y = 0; y < nRows; y++) {
      _tiles[x][y].flush();
    }
  }
}

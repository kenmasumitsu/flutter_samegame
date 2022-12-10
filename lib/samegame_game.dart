import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter_samegame/components/tile_board.dart';
import 'package:flutter_samegame/layers/gameclear_layer.dart';

import 'components/menu_bar.dart';
import 'components/tile.dart';
import 'layers/gameover_layer.dart';
import 'layers/menu_layer.dart';

enum Status {
  suspend,
  running,
  gameover,
  gameclear,
}

enum Level {
  easy(12, 8, 3),
  normal(15, 10, 4),
  hard(20, 12, 5);

  const Level(this.nColumns, this.nRows, this.nColors);

  final int nColumns;
  final int nRows;
  final int nColors;

  Level next() {
    switch (this) {
      case Level.easy:
        return Level.normal;
      case Level.normal:
        return Level.hard;
      case Level.hard:
        return Level.hard;
    }
  }

  Level prev() {
    switch (this) {
      case Level.easy:
        return Level.easy;
      case Level.normal:
        return Level.easy;
      case Level.hard:
        return Level.normal;
    }
  }

  bool isEasiest() {
    return this == Level.easy;
  }

  bool isHardest() {
    return this == Level.hard;
  }
}

class SamegameGame extends FlameGame
    with HasTappableComponents, HasTappablesBridge {
  static const menuBarHeight = 120.0;
  static const menuBarWidth = 800.0;

  static const tileBoardWidth = 1600.0;
  static const tileBoardHeight = 1600.0;

  Status _status = Status.gameover;
  Status get status => _status;

  Level _level = Level.easy;

  Level get level => _level;

  @override
  Future<void>? onLoad() {
    super.onLoad();

    final menuBar = MenuBar()
      ..position = Vector2(0, 0)
      ..size = Vector2(menuBarWidth, menuBarHeight);
    final world = World()..add(menuBar);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize =
          Vector2(tileBoardWidth, tileBoardHeight + menuBarHeight)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    add(camera);

    return null;
  }

  void onTap(Tile tile) {
    tileBoard?.onTap(tile);
  }

  int getScore() {
    return tileBoard?.score ?? 0;
  }

  World get world {
    final worlds = children.query<World>();
    assert(worlds.length == 1);
    final world = worlds[0];
    return world;
  }

  TileBoard? get tileBoard {
    final worlds = children.query<World>();
    assert(worlds.length == 1);
    final world = worlds[0];

    final tileBoards = world.children.query<TileBoard>();
    if (tileBoards.isEmpty) {
      return null;
    } else {
      assert(tileBoards.length == 1);
      return tileBoards[0];
    }
  }

  void start(Level level) {
    _level = level;
    _reset();
    _status = Status.running;
  }

  void _reset() {
    tileBoard?.removeFromParent();

    final tb = TileBoard(
      nColumns: _level.nColumns,
      nRows: _level.nRows,
      nColors: _level.nColors,
    )
      ..position = Vector2(0, menuBarHeight)
      ..size = Vector2(tileBoardWidth, tileBoardHeight);

    world.add(tb);
  }

  void suspend() {
    _status = Status.suspend;
  }

  void resume() {
    assert(_status == Status.suspend);
    _status = Status.running;
  }

  bool isRunning() {
    return _status == Status.running;
  }

  bool isSuspend() {
    return _status == Status.suspend;
  }

  void showMenu() {
    suspend();
    overlays.add(MenuLayer.name);
  }

  void gameClear() {
    _status = Status.gameclear;
    overlays.add(GameOverLayer.name);
  }

  void gameOver() {
    _status = Status.gameover;
    overlays.add(GameOverLayer.name);
  }
}

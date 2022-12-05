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
  stopped,
  suspend,
  running,
}

class SamegameGame extends FlameGame
    with HasTappableComponents, HasTappablesBridge {
  static const menuBarHeight = 24.0;

  Status status = Status.stopped;
  late final TileBoard tileBoard;
  late final MenuBar menuBar;

  @override
  Future<void>? onLoad() {
    super.onLoad();

    const numOfColTiles = 12;
    const numOfRowTiles = 8;
    const tileBoardWidth = Tile.tileWidth * numOfColTiles;
    const tileBoardHeight = Tile.tileHeight * numOfRowTiles;

    menuBar = MenuBar()
      ..position = Vector2(0, 0)
      ..size = Vector2(tileBoardWidth, menuBarHeight);
    tileBoard = TileBoard(xMax: numOfColTiles, yMax: numOfRowTiles)
      ..position = Vector2(0, menuBarHeight)
      ..size = Vector2(tileBoardWidth, tileBoardHeight);

    final world = World()
      ..add(tileBoard)
      ..add(menuBar);

    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize =
          Vector2(tileBoardWidth, menuBarHeight + tileBoardHeight)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    add(camera);

    return null;
  }

  void onTap(Tile tile) {
    tileBoard.onTap(tile);
  }

  int getScore() {
    return tileBoard.score;
  }

  void reset() {
    tileBoard.reset();
  }

  void start() {
    status = Status.running;
    tileBoard.reset();
  }

  void suspend() {
    status = Status.suspend;
  }

  void resume() {
    assert(status == Status.suspend);
    status = Status.running;
  }

  bool isRunning() {
    return status == Status.running;
  }

  bool isSuspend() {
    return status == Status.suspend;
  }

  void showMenu() {
    suspend();
    overlays.add(MenuLayer.name);
  }

  void gameClear() {
    status = Status.stopped;
    overlays.add(GameClearLayer.name);
  }

  void gameOver() {
    status = Status.stopped;
    overlays.add(GameOverLayer.name);
  }
}

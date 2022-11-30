import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter_samegame/components/tile_board.dart';

import 'components/menu_bar.dart';
import 'components/tile.dart';

class SamegameGame extends FlameGame with HasTappableComponents {
  static const statusBarHeight = 24.0;

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
      ..size = Vector2(tileBoardWidth, statusBarHeight);
    tileBoard = TileBoard(xMax: numOfColTiles, yMax: numOfRowTiles)
      ..position = Vector2(0, statusBarHeight)
      ..size = Vector2(tileBoardWidth, tileBoardHeight);

    final world = World()
      ..add(tileBoard)
      ..add(menuBar);

    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize =
          Vector2(tileBoardWidth, statusBarHeight + tileBoardHeight)
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
}

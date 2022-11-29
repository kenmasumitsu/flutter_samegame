import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter_samegame/components/tile_board.dart';

import 'components/tile.dart';

class SamegameGame extends FlameGame with HasTappableComponents {
  late final TileBoard tileBoard;

  @override
  Future<void>? onLoad() {
    super.onLoad();

    tileBoard = TileBoard(xMax: 12, yMax: 8);
    final world = World()..add(tileBoard);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = tileBoard.size
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    add(camera);

    return null;
  }

  void onTap(Tile tile) {
    tileBoard.onTap(tile);
  }
}

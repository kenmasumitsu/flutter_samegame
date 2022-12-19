import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_samegame/flame/components/tile_board.dart';

import 'components/tile.dart';
import '../components/gameover_layer.dart';
import '../components/menu_layer.dart';

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
  static const tileBoardWidth = 1600.0;
  static const tileBoardHeight = 1600.0;

  Status _status = Status.gameover;
  Status get status => _status;
  set status(Status v) {
    _status = v;
    onStatusChanged(v);
  }

  Level _level = Level.easy;
  Level get level => _level;

  final Function(Status) onStatusChanged;
  final Function(int) onScoreChanged;

  SamegameGame({
    required this.onStatusChanged,
    required this.onScoreChanged,
  });

  @override
  Future<void>? onLoad() {
    super.onLoad();

    FlameAudio.audioCache.loadAll(
      ['select.mp3', 'flush.mp3'],
    );

    final world = World();
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(tileBoardWidth, tileBoardHeight)
      ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.anchor = Anchor.topLeft;

    add(camera);

    return null;
  }

  Future<void> onTap(Tile tile) async {
    FlameAudio.play('select.mp3', volume: 0.2);

    tileBoard?.onTap(tile);
  }

  void setScore(int score) {
    onScoreChanged(score);
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
    status = Status.running;
  }

  void _reset() {
    tileBoard?.removeFromParent();

    final tb = TileBoard(
      nColumns: _level.nColumns,
      nRows: _level.nRows,
      nColors: _level.nColors,
    )
      ..position = Vector2(0, 0)
      ..size = Vector2(tileBoardWidth, tileBoardHeight);

    world.add(tb);
  }

  void _suspend() {
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

  void showMenu({bool suspend = false}) {
    if (overlays.isActive(MenuLayer.name)) {
      return;
    }

    if (suspend) {
      _suspend();
    }

    overlays.clear();
    overlays.add(MenuLayer.name);
  }

  Future<void> gameClear() async {
    FlameAudio.play('jaja_n.mp3', volume: 0.1);

    status = Status.gameclear;
    overlays.add(GameOverLayer.name);
  }

  void gameOver() {
    status = Status.gameover;
    overlays.add(GameOverLayer.name);
  }
}

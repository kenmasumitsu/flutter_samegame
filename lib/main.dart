import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samegame/layers/gameover_layer.dart';
import 'package:flutter_samegame/samegame_game.dart';
import 'package:flutter_samegame/layers/menu_layer.dart';

import 'layers/gameclear_layer.dart';

void main() {
  final game = SamegameGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        MenuLayer.name: (BuildContext ctx, SamegameGame game) {
          return MenuLayer(game: game);
        },
        GameOverLayer.name: (BuildContext ctx, SamegameGame game) {
          return GameOverLayer(
            game: game,
          );
        },
        GameClearLayer.name: (BuildContext ctx, SamegameGame game) {
          return GameClearLayer(
            game: game,
          );
        }
      },
      initialActiveOverlays: const ['menu'],
    ),
  );
}

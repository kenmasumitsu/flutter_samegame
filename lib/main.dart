import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samegame/samegame_game.dart';
import 'package:flutter_samegame/layers/menu_layer.dart';

void main() {
  final game = SamegameGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        MenuLayer.name: (BuildContext ctx, SamegameGame game) {
          return MenuLayer(game);
        },
        'game_over': (BuildContext ctx, SamegameGame game) {
          return const Text('bar');
        }
      },
      initialActiveOverlays: const ['menu'],
    ),
  );
}

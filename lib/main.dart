import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samegame/samegame_game.dart';

void main() {
  final game = SamegameGame();
  runApp(GameWidget(game: game));
}

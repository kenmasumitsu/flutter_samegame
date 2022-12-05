import 'package:flutter/material.dart';

import '../palatte.dart';
import '../samegame_game.dart';

class GameOverLayer extends StatelessWidget {
  static const name = 'gameover';

  final SamegameGame game;
  const GameOverLayer({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        color: Palatte.menuBackgroundd.color,
        width: 240,
        height: 360,
        child: const Text('Game Over'),
      ),
    );
  }
}

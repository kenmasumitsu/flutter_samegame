import 'package:flutter/material.dart';

import '../constants/palatte.dart';
import '../samegame_game.dart';
import 'menu_layer.dart';

class GameOverLayer extends StatelessWidget {
  static const name = 'gameover';

  final SamegameGame game;
  const GameOverLayer({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title =
        game.status == Status.gameclear ? 'Congraturation' : 'Game Over';

    return Center(
      child: SizedBox(
        width: 240,
        height: 360,
        child: Card(
          color: Palatte.menuBackground.color,
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                title,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Go to Menu');
                  game.overlays.remove(GameOverLayer.name);
                  game.overlays.add(MenuLayer.name);
                },
                child: const Text('Go to Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

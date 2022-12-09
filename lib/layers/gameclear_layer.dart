import 'package:flutter/material.dart';
import 'package:flutter_samegame/layers/menu_layer.dart';

import '../constants/palatte.dart';
import '../samegame_game.dart';

class GameClearLayer extends StatelessWidget {
  static const name = 'gameclear';

  final SamegameGame game;
  const GameClearLayer({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                'Game Clear',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Go to Menu');
                  game.overlays.remove(GameClearLayer.name);
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

import 'package:flutter/material.dart';
import 'package:flutter_samegame/samegame_game.dart';

class MenuLayer extends StatelessWidget {
  static const name = 'menu';

  final SamegameGame game;

  const MenuLayer(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        color: Color.fromARGB(180, 28, 28, 221),
        width: 240,
        height: 360,
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            if (game.isSuspend()) ...[
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove(MenuLayer.name);
                  game.resume();
                },
                child: const Text('Bak to the Game'),
              ),
              const SizedBox(
                height: 32,
              ),
            ],
            ElevatedButton(
              onPressed: () {
                debugPrint('start');
                game.overlays.remove(MenuLayer.name);
                game.start();
              },
              child: const Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}

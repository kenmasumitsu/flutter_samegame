import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samegame/flame/samegame_game.dart';
import 'package:flutter_samegame/providers/high_score_provider.dart';
import 'package:flutter_samegame/providers/game_provider.dart';

class Menu extends ConsumerWidget {
  final SamegameGame game;

  const Menu(this.game, {super.key});

  bool _buttonEnabled(Status status) {
    if (status == Status.running) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(statusProvider);
    final score = ref.watch(scoreProvider);
    final highScore = ref.watch(highScoreProvider(game.level));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: _buttonEnabled(status)
                ? () {
                    game.showMenu(suspend: true);
                  }
                : null,
            child: const Text('Menu'),
          ),
          const SizedBox(
            width: 24,
          ),
          Text('Score: $score'),
          const SizedBox(
            width: 24,
          ),
          Text('High Score: ${highScore.score}'),
        ],
      ),
    );
  }
}

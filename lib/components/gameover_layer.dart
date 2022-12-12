import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samegame/model/high_score.dart';
import 'package:flutter_samegame/providers/game_provider.dart';
import 'package:flutter_samegame/providers/high_score_provider.dart';

import '../constants/palatte.dart';
import '../flame/samegame_game.dart';

class GameOverLayer extends ConsumerStatefulWidget {
  static const name = 'gameover';

  const GameOverLayer({Key? key, required this.game}) : super(key: key);

  final SamegameGame game;

  @override
  GameOverLayerState createState() => GameOverLayerState();
}

class GameOverLayerState extends ConsumerState<GameOverLayer> {
  String? _name;

  @override
  void initState() {
    super.initState();
    _name = null;
  }

  @override
  Widget build(BuildContext context) {
    // Use read instead of watch
    final highScore = ref.read(highScoreProvider(widget.game.level));
    final score = ref.read(scoreProvider);
    final bool isHighScore = highScore.score < score;

    final theme = Theme.of(context);

    final title = widget.game.status == Status.gameclear
        ? 'Congraturation!'
        : 'Game Over';

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
                style:
                    theme.textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Score: $score',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 24,
              ),
              if (isHighScore) ...[
                Text(
                  "High score",
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    maxLength: 16,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: "Input your name",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      _name = value;
                    },
                  ),
                ),
              ],
              ElevatedButton(
                onPressed: () {
                  debugPrint('Go to Menu');
                  if (_name != null) {
                    HighScoreNotifier.postHighScore(
                        widget.game.level,
                        HighScore(
                          score: score,
                          name: _name!,
                          timestamp: DateTime.now(),
                        ));
                  }
                  widget.game.showMenu();
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

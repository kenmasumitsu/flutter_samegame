import 'package:flutter/material.dart';
import 'package:flutter_samegame/constants/palatte.dart';
import 'package:flutter_samegame/samegame_game.dart';

class MenuLayer extends StatefulWidget {
  static const name = 'menu';

  final SamegameGame game;

  const MenuLayer({super.key, required this.game});

  @override
  State<MenuLayer> createState() => _MenuLayerState();
}

extension LevelExt on Level {
  String get name {
    switch (this) {
      case Level.easy:
        return "EASY";
      case Level.normal:
        return "NORMAL";
      case Level.hard:
        return "HARD";
    }
  }
}

class _MenuLayerState extends State<MenuLayer> {
  Level level = Level.easy;

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
              // Text(
              //   'New Game',
              //   style: theme.textTheme.titleLarge,
              // ),
              if (widget.game.isSuspend()) ...[
                ElevatedButton(
                  onPressed: () {
                    widget.game.overlays.remove(MenuLayer.name);
                    widget.game.resume();
                  },
                  child: const Text('Back to the Game'),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
              ElevatedButton(
                onPressed: () {
                  debugPrint('start');
                  widget.game.overlays.remove(MenuLayer.name);
                  widget.game.start(level);
                },
                child: const Text('New Game'),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        level = level.prev();
                      });
                    },
                    child: const Icon(Icons.arrow_left),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 72,
                    child: Center(
                      child: Text(
                        level.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        level = level.next();
                      });
                    },
                    child: const Icon(Icons.arrow_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

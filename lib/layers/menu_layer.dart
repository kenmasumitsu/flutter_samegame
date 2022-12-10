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
  Level _level = Level.easy;

  @override
  void initState() {
    super.initState();
    _level = widget.game.level;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: 240,
        height: 360,
        child: Card(
          color: Palatte.menuBackground.color,
          //color: Colors.blue,
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
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
                  widget.game.start(_level);
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
                    onPressed: _level.isEasiest()
                        ? null
                        : () {
                            setState(() {
                              _level = _level.prev();
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
                        _level.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: _level.isHardest()
                        ? null
                        : () {
                            setState(() {
                              _level = _level.next();
                            });
                          },
                    child: const Icon(Icons.arrow_right),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "High Score",
                style:
                    theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Name",
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "1234",
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

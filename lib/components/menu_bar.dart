import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samegame/layers/menu_layer.dart';
import 'package:flutter_samegame/samegame_game.dart';

class MenuBar extends PositionComponent with HasGameRef<SamegameGame> {
  late final MenuButton resetText;
  late final TextComponent scoreText;

  @override
  Future<void>? onLoad() {
    super.onLoad();

    final regular = TextPaint(
      style: const TextStyle(color: Colors.white),
    );

    resetText = MenuButton()
      ..text = "Menu"
      ..textRenderer = regular
      ..position = Vector2(0, 0);
    add(resetText);

    scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: regular,
    )..position = Vector2(48, 0);
    add(scoreText);

    return null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    int score = gameRef.getScore();
    scoreText.text = 'Score: $score';
  }
}

class MenuButton extends TextComponent
    with TapCallbacks, HasGameRef<SamegameGame> {
  @override
  void onTapUp(TapUpEvent event) {
    gameRef.suspend();
    gameRef.overlays.add(MenuLayer.name);
  }
}

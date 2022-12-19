import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samegame/components/menu.dart';
import 'package:flutter_samegame/providers/game_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'firebase_options.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/gameover_layer.dart';
import 'components/menu_layer.dart';
import 'flame/samegame_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LdAoHwjAAAAADlqTEypBWF2OqGYgxq8KR7wLHey',
    androidProvider: AndroidProvider.debug,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  try {
    await FirebaseAuth.instance.signInAnonymously();
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        debugPrint("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        debugPrint("Unknown error.");
    }
  }

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = SamegameGame(
      onScoreChanged: (int score) {
        ref.read(scoreProvider.notifier).state = score;
      },
      onStatusChanged: (Status status) {
        ref.read(statusProvider.notifier).state = status;
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samegame',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
          children: [
            Menu(game),
            Expanded(
              child: GameWidget(
                game: game,
                overlayBuilderMap: {
                  MenuLayer.name: (BuildContext ctx, SamegameGame game) {
                    return MenuLayer(game: game);
                  },
                  GameOverLayer.name: (BuildContext ctx, SamegameGame game) {
                    return GameOverLayer(
                      game: game,
                    );
                  },
                },
                initialActiveOverlays: const [MenuLayer.name],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

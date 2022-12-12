import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samegame/model/high_score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../flame/samegame_game.dart';

class HighScoreNotifier extends StateNotifier<HighScore> {
  HighScoreNotifier(Level level)
      : super(
          HighScore(
            score: 0,
            name: 'Nobody',
            timestamp: DateTime.now(),
          ),
        ) {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("highscore").doc(level.name);
    docRef.snapshots().listen(
      (event) {
        debugPrint("current data: ${event.data()}");
        final data = event.data();
        if (data == null) {
          return;
        }
        final score = data['score'] as int;
        final name = data['name'] as String;
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        state = state.copyWith(
          name: name,
          score: score,
          timestamp: timestamp,
        );
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );
  }

  static void postHighScore(Level level, HighScore highScore) {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("highscore").doc(level.name);
    db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists ||
          _isHighScore(snapshot.get('score'), highScore.score)) {
        transaction.set(docRef, {
          "score": highScore.score,
          "name": highScore.name,
          "timestamp": Timestamp.fromDate(highScore.timestamp),
        });
      }
    }).then(
      (value) => debugPrint("DocumentSnapshot successfully updated!"),
      onError: (e) => debugPrint("Error updating document $e"),
    );
  }
}

bool _isHighScore(int fsScore, int score) {
  return fsScore < score;
}

final highScoreProvider =
    StateNotifierProvider.family<HighScoreNotifier, HighScore, Level>(
  (ref, level) {
    return HighScoreNotifier(level);
  },
);

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samegame/model/high_score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../samegame_game.dart';

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
      final current = snapshot.data();
      if (current != null) {
        final currentScore = current['score'] as int;
        if (highScore.score < currentScore) {
          return;
        }
      }

      transaction.update(docRef, {
        "score": highScore.score,
        "name": highScore.name,
        "timestamp": Timestamp.fromDate(highScore.timestamp),
      });
    }).then(
      (value) => debugPrint("DocumentSnapshot successfully updated!"),
      onError: (e) => debugPrint("Error updating document $e"),
    );
  }
}

final highScoreProvider =
    StateNotifierProvider.family<HighScoreNotifier, HighScore, Level>(
  (ref, level) {
    return HighScoreNotifier(level);
  },
);

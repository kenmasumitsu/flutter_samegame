import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../flame/samegame_game.dart';

final scoreProvider = StateProvider<int>((ref) {
  return 0;
});

final statusProvider = StateProvider<Status>((ref) {
  return Status.gameover;
});

final levelProvider = StateProvider<Level>((ref) {
  return Level.easy;
});

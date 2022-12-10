import 'package:freezed_annotation/freezed_annotation.dart';

part 'high_score.freezed.dart';

@freezed
class HighScore with _$HighScore {
  const factory HighScore({
    required int score,
    required String name,
    required DateTime timestamp,
  }) = _HighScore;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'high_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HighScore {
  int get score => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HighScoreCopyWith<HighScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighScoreCopyWith<$Res> {
  factory $HighScoreCopyWith(HighScore value, $Res Function(HighScore) then) =
      _$HighScoreCopyWithImpl<$Res, HighScore>;
  @useResult
  $Res call({int score, String name, DateTime timestamp});
}

/// @nodoc
class _$HighScoreCopyWithImpl<$Res, $Val extends HighScore>
    implements $HighScoreCopyWith<$Res> {
  _$HighScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? name = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HighScoreCopyWith<$Res> implements $HighScoreCopyWith<$Res> {
  factory _$$_HighScoreCopyWith(
          _$_HighScore value, $Res Function(_$_HighScore) then) =
      __$$_HighScoreCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int score, String name, DateTime timestamp});
}

/// @nodoc
class __$$_HighScoreCopyWithImpl<$Res>
    extends _$HighScoreCopyWithImpl<$Res, _$_HighScore>
    implements _$$_HighScoreCopyWith<$Res> {
  __$$_HighScoreCopyWithImpl(
      _$_HighScore _value, $Res Function(_$_HighScore) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? name = null,
    Object? timestamp = null,
  }) {
    return _then(_$_HighScore(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_HighScore implements _HighScore {
  const _$_HighScore(
      {required this.score, required this.name, required this.timestamp});

  @override
  final int score;
  @override
  final String name;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'HighScore(score: $score, name: $name, timestamp: $timestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HighScore &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, score, name, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HighScoreCopyWith<_$_HighScore> get copyWith =>
      __$$_HighScoreCopyWithImpl<_$_HighScore>(this, _$identity);
}

abstract class _HighScore implements HighScore {
  const factory _HighScore(
      {required final int score,
      required final String name,
      required final DateTime timestamp}) = _$_HighScore;

  @override
  int get score;
  @override
  String get name;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$_HighScoreCopyWith<_$_HighScore> get copyWith =>
      throw _privateConstructorUsedError;
}

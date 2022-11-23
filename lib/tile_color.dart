import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class TileColor {
  final Color normal;
  final Color selected;

  const TileColor._(this.normal, this.selected);

  static TileColor red = const TileColor._(
    Colors.red,
    Colors.grey,
  );
  static TileColor yellow = const TileColor._(
    Colors.yellow,
    Colors.grey,
  );
  static TileColor blue = const TileColor._(
    Colors.blue,
    Colors.grey,
  );

  static late final List<TileColor> _singletones = [
    red,
    yellow,
    blue,
  ];

  static TileColor random() {
    final n = Random().nextInt(_singletones.length);
    return _singletones[n];
  }

  @override
  String toString() {
    return '$normal';
  }
}

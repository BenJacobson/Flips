import 'package:flips/model/board/coordinate.dart';
import 'package:flutter/material.dart';

import 'dart:math';

abstract class Cell {
  final Color color;
  bool flipped;
  bool selected;

  Cell({@required this.color, this.flipped = false, this.selected = false});

  Iterable<int> flips(int i, int j, int width, int height);
}

class BlueCell extends Cell {
  BlueCell({flipped = false, selected = false})
      : super(color: Colors.lightBlue, flipped: flipped, selected: selected);

  Iterable<int> flips(int iFlip, int jFlip, int width, int height) sync* {
    for (int i = iFlip - 1; i <= iFlip + 1; ++i) {
      for (int j = jFlip - 1; j <= jFlip + 1; ++j) {
        yield Coordinates.coordsToIndex(i, j, width);
      }
    }
  }
}

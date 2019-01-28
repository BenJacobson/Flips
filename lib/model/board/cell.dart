import 'package:flutter/material.dart';

abstract class Cell {
  final Color color;
  bool flipped;
  bool selected;

  Cell({@required this.color, this.flipped = false, this.selected = false});
}

class BlueCell extends Cell {
  BlueCell({flipped = false, selected = false})
      : super(color: Colors.lightBlue, flipped: flipped, selected: selected);
}

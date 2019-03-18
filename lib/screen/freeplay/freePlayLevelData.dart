import 'package:flips/model/board/cell.dart';
import 'package:flutter/material.dart';

class FreePlayLevelData {
  final Set<CellType> cellTypes;
  final int height;
  final int width;

  FreePlayLevelData({
    @required this.cellTypes,
    @required this.height,
    @required this.width,
  });
}

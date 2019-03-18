import 'package:flips/model/board/cell.dart';
import 'package:flutter/material.dart';

class LevelData {
  static LevelData fromSerializedLevelData(
    int height,
    int width,
    String serializedLevelData,
  ) {
    assert(width * height == serializedLevelData.length, serializedLevelData);
    List<List<LevelCell>> cells = Iterable.generate(height, (i) {
      return Iterable.generate(width, (j) {
        String c = serializedLevelData[i * width + j];
        return LevelCell(
          cellType: Cell.deserializeCellType(c),
          selected: c != c.toUpperCase(),
        );
      }).toList();
    }).toList();
    return LevelData(
      cells: cells,
    );
  }

  final List<List<LevelCell>> _cells;

  LevelData({
    @required cells,
  }) : _cells = cells {
    assert(height > 0);
    assert(width > 0);
  }

  int get width => _cells[0].length;

  int get height => _cells.length;

  CellType getCellType(int i, int j) => _cells[i][j].cellType;

  bool getSelected(int i, int j) => _cells[i][j].selected;
}

class LevelCell {
  final CellType cellType;
  final bool selected;

  LevelCell({
    @required this.cellType,
    @required this.selected,
  });
}

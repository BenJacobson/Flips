import 'package:flips/global/preferences.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flutter/material.dart';

class LevelData {
  static LevelData fromSerializedLevelData({
    @required int height,
    @required int width,
    @required String serializedLevelData,
    @required String displayName,
    @required bool completed,
  }) {
    assert(serializedLevelData != null);
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
      completed: completed,
      serializedLevelData: serializedLevelData,
      displayName: displayName,
    );
  }

  final List<List<LevelCell>> _cells;
  final List<VoidCallback> _completedListeners = List();
  final String serializedLevelData;
  final String displayName;

  bool _completed;

  LevelData({
    @required cells,
    completed = false,
    this.serializedLevelData = "",
    this.displayName,
  })  : _cells = cells,
        _completed = completed {
    assert(height > 0);
    assert(width > 0);
  }

  bool get completed => _completed;

  int get width => _cells[0].length;

  int get height => _cells.length;

  void addCompletedListener(VoidCallback callback) =>
      _completedListeners.add(callback);

  CellType getCellType(int i, int j) => _cells[i][j].cellType;

  bool getSelected(int i, int j) => _cells[i][j].selected;

  void setCompleted(bool value) {
    if (value != _completed) {
      _completed = value;
      Preferences.setLevelCompleted(serializedLevelData, _completed);
      _completedListeners.forEach((listener) => listener());
    }
  }
}

class LevelCell {
  final CellType cellType;
  final bool selected;

  LevelCell({
    @required this.cellType,
    @required this.selected,
  });
}

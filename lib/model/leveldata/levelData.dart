import 'package:flips/global/preferences.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flutter/material.dart';

class LevelData {
  static Future<LevelData> fromSerializedLevelData(
    int height,
    int width,
    String serializedLevelData,
  ) async {
    assert(width * height == serializedLevelData.length, serializedLevelData);
    bool levelCompleted =
        await Preferences.getLevelCompleted(serializedLevelData);
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
      completed: levelCompleted,
      serializedLevelData: serializedLevelData,
    );
  }

  final List<List<LevelCell>> _cells;
  final List<VoidCallback> _completedListeners = List();
  final String serializedLevelData;

  bool _completed;

  LevelData({
    @required cells,
    completed = false,
    this.serializedLevelData = "",
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

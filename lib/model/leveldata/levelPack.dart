import 'package:flips/model/board/cell.dart';
import 'package:flips/model/leveldata/levelData.dart';
import 'package:flutter/material.dart';

class LevelPack {
  static LevelPack fromSerializedLevelPack(String serializedLevelPack) {
    List<String> lines = serializedLevelPack.split('\n');
    assert(lines.length == 22);

    Set<CellType> cellTypes = lines[0]
        .trim()
        .split('')
        .map((c) => Cell.deserializeCellType(c))
        .toSet();

    List<int> size = lines[1]
        .split(' ')
        .map((n) => n.trim())
        .map((n) => int.parse(n))
        .toList();
    assert(size.length == 2);

    int height = size[0];
    int width = size[1];

    List<LevelData> levelData = lines.skip(2).map((line) {
      line = line.trim();
      assert(line.split('').fold(
          true,
          (bool good, String c) =>
              cellTypes.contains(Cell.deserializeCellType(c)) && good));
      return LevelData.fromSerializedLevelData(height, width, line);
    }).toList();

    return LevelPack._internal(
      cellTypes: cellTypes,
      levelData: levelData,
      height: height,
      width: width,
    );
  }

  final List<LevelData> _levelData;
  final Set<CellType> _cellTypes;
  final int height;
  final int width;

  LevelPack._internal({
    @required cellTypes,
    @required levelData,
    @required this.height,
    @required this.width,
  })  : _cellTypes = cellTypes,
        _levelData = levelData;

  int get length => _levelData.length;

  LevelData operator [](int index) => _levelData[index];

  bool usesCellType(CellType cellType) => _cellTypes.contains(cellType);
}

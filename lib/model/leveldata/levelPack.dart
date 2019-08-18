import 'package:flips/model/board/cell.dart';
import 'package:flips/model/leveldata/levelData.dart';
import 'package:flutter/material.dart';

typedef LevelNameGenerator = String Function(int);

class LevelPack {
  static Future<LevelPack> fromSerializedLevelPack(
      String serializedLevelPack, LevelNameGenerator levelNameGenerator) async {
    List<String> lines = serializedLevelPack
        .split('\n')
        .map((level) => level.trim())
        .where((level) => level.isNotEmpty)
        .toList();
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

    int levelNumber = 1;
    List<LevelData> levelData = await Future.wait(lines.skip(2).map((line) {
      line = line.trim();
      assert(line.split('').fold(
          true,
          (bool good, String c) =>
              cellTypes.contains(Cell.deserializeCellType(c)) && good));
      return LevelData.fromSerializedLevelData(
        height: height,
        width: width,
        serializedLevelData: line,
        displayName: levelNameGenerator != null
            ? levelNameGenerator(levelNumber++)
            : null,
      );
    }));

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

  int _numCompleted = 0;

  LevelPack._internal({
    @required cellTypes,
    @required levelData,
    @required this.height,
    @required this.width,
  })  : _cellTypes = cellTypes,
        _levelData = levelData {
    _levelData.forEach((levelData) {
      if (levelData.completed) {
        _numCompleted++;
      }
    });
  }

  int get numLevels => _levelData.length;

  int get numCompleted => _numCompleted;

  LevelData operator [](int index) => _levelData[index];

  bool usesCellType(CellType cellType) => _cellTypes.contains(cellType);
}

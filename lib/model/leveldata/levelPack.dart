import 'package:flips/global/preferences.dart';
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

    List<int> size = lines[0]
        .split(' ')
        .map((n) => n.trim())
        .map((n) => int.parse(n))
        .toList();
    assert(size.length == 2);

    int height = size[0];
    int width = size[1];

    int levelNumber = 1;
    List<LevelData> levelData = await Future.wait(lines.skip(1).map((line) async {
      line = line.trim();
      bool completed = await Preferences.getLevelCompleted(line);
      return LevelData.fromSerializedLevelData(
        height: height,
        width: width,
        serializedLevelData: line,
        displayName: levelNameGenerator != null
            ? levelNameGenerator(levelNumber++)
            : null,
        completed: completed,
      );
    }));

    return LevelPack._internal(
      levelData: levelData,
      height: height,
      width: width,
    );
  }

  final List<LevelData> _levelData;
  final int height;
  final int width;

  int _numCompleted = 0;

  LevelPack._internal({
    @required levelData,
    @required this.height,
    @required this.width,
  }) : _levelData = levelData {
    _levelData.forEach((levelData) {
      if (levelData.completed) {
        _numCompleted++;
      }
    });
  }

  int get numLevels => _levelData.length;

  int get numCompleted => _numCompleted;

  LevelData operator [](int index) => _levelData[index];
}

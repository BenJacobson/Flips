import 'package:flips/model/leveldata/levelData.dart';
import 'package:flips/model/leveldata/levelPack.dart';
import 'package:flips/model/leveldata/levelSequencer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

bool isInRange(int val, int low, int high) => val >= low && val <= high;

class LevelSelectionBloc with LevelSequencer {
  final String _root = "leveldata/";
  final String _manifest = "manifest";
  final List<String> levelPackOrder = List<String>();
  final Map<String, LevelPack> levelPacks = Map<String, LevelPack>();

  AssetBundle _assetBundle;
  Future<void> _loaded;
  int _levelPackIndex = 0;
  int _levelDataIndex = 0;

  Future<void> get loaded => _loaded;

  LevelSelectionBloc({AssetBundle assetBundle}) {
    _assetBundle = assetBundle;
    _loaded = _loadLevels();
  }

  void setLevel(int levelPackIndex, int levelDataIndex) {
    if (!isInRange(levelPackIndex, 0, levelPackOrder.length - 1)) {
      return;
    }

    LevelPack levelPack = levelPacks[levelPackOrder[_levelPackIndex]];
    if (!isInRange(levelDataIndex, 0, levelPack.numLevels - 1)) {
      return;
    }

    _levelPackIndex = levelPackIndex;
    _levelDataIndex = levelDataIndex;
  }

  LevelData getCurrentLevel() {
    if (!isInRange(_levelPackIndex, 0, levelPackOrder.length - 1)) {
      return null;
    }

    LevelPack levelPack = levelPacks[levelPackOrder[_levelPackIndex]];
    if (!isInRange(_levelDataIndex, 0, levelPack.numLevels - 1)) {
      return null;
    }

    return levelPack[_levelDataIndex];
  }

  LevelData getNextLevel() {
    if (!isInRange(_levelPackIndex, 0, levelPackOrder.length - 1)) {
      return null;
    }

    _levelDataIndex++;
    LevelPack levelPack = levelPacks[levelPackOrder[_levelPackIndex]];
    if (!isInRange(_levelDataIndex, 0, levelPack.numLevels - 1)) {
      _levelPackIndex++;
      _levelDataIndex = 0;
      if (!isInRange(_levelPackIndex, 0, levelPackOrder.length - 1)) {
        return null;
      }
      levelPack = levelPacks[levelPackOrder[_levelPackIndex]];
      if (!isInRange(_levelDataIndex, 0, levelPack.numLevels - 1)) {
        return null;
      }
    }

    return levelPack[_levelDataIndex];
  }

  bool hasNextLevel() {
    if (!isInRange(_levelPackIndex, 0, levelPackOrder.length - 1)) {
      return false;
    }
    LevelPack levelPack = levelPacks[levelPackOrder[_levelPackIndex]];
    if (isInRange(_levelDataIndex + 1, 0, levelPack.numLevels - 1)) {
      return true;
    }
    if (!isInRange(_levelPackIndex + 1, 0, levelPackOrder.length - 1)) {
      return false;
    }
    levelPack = levelPacks[levelPackOrder[_levelPackIndex + 1]];
    return isInRange(0, 0, levelPack.numLevels - 1);
  }

  Future<void> _loadLevels() async {
    String levelPacksFile = await _loadFile(_manifest);
    levelPacksFile
        .split("\n")
        .map((levelPack) => levelPack.trim())
        .where((levelPack) => levelPack.isNotEmpty)
        .forEach(levelPackOrder.add);
    await Future.wait(levelPackOrder.map((levelPackFile) async {
      String serializedLevelPack = await _loadFile(levelPackFile);
      if (serializedLevelPack != null) {
        LevelPack levelPack = await LevelPack.fromSerializedLevelPack(
            serializedLevelPack, (levelNum) => "Level $levelNum");
        levelPacks.putIfAbsent(levelPackFile, () => levelPack);
      }
    }));
  }

  Future<String> _loadFile(String name) async {
    return await _assetBundle.loadString(_root + name.trim());
  }
}

class LevelSelectionBlocInheritedWidget extends InheritedWidget {
  final LevelSelectionBloc levelSelectionBloc;

  LevelSelectionBlocInheritedWidget(
      {@required this.levelSelectionBloc, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LevelSelectionBlocInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(LevelSelectionBlocInheritedWidget);
}

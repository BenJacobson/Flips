import 'package:flips/model/leveldata/levelPack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

class LevelSelectionBloc {
  final String _root = "leveldata/";
  final String _manifest = "manifest";
  final List<String> levelPackOrder = List();
  final Map<String, LevelPack> levelPacks = Map();

  AssetBundle _assetBundle;
  Future<void> _loaded;

  Future<void> get loaded => _loaded;

  LevelSelectionBloc({AssetBundle assetBundle}) {
    _assetBundle = assetBundle;
    _loaded = _loadLevels();
  }

  Future<void> _loadLevels() async {
    String levelPacksFile = await _loadFile(_manifest);
    levelPacksFile.split("\n").forEach(levelPackOrder.add);
    await Future.wait(levelPackOrder.map((levelPack) async {
      String serializedLevelPack = await _loadFile(levelPack);
      if (serializedLevelPack != null) {
        levelPacks.putIfAbsent(levelPack,
            () => LevelPack.fromSerializedLevelPack(serializedLevelPack));
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

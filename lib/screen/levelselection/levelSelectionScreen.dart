import 'package:flips/screen/levelselection/levelPackWidget.dart';
import 'package:flips/screen/levelselection/levelSelectionBloc.dart';
import 'package:flutter/material.dart';

class LevelSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Levels"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: LevelSelectionBlocInheritedWidget(
        levelSelectionBloc: LevelSelectionBloc(
          assetBundle: DefaultAssetBundle.of(context),
        ),
        child: _LevelSelectionWidget(),
      ),
    );
  }
}

class _LevelSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LevelSelectionBloc levelSelectionBloc =
        LevelSelectionBlocInheritedWidget.of(context).levelSelectionBloc;
    return FutureBuilder(
      future: levelSelectionBloc.loaded,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ListView(
          children: levelSelectionBloc.levelPackOrder
              .map((levelPackName) => LevelPackWidget(
                    levelPack: levelSelectionBloc.levelPacks[levelPackName],
                  ))
              .toList(),
        );
      },
    );
  }
}

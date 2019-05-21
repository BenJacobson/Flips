import 'package:flips/screen/level/levelScreen.dart';
import 'package:flips/screen/levelselection/levelPackWidget.dart';
import 'package:flips/screen/levelselection/levelSelectionBloc.dart';
import 'package:flips/widget/animation/expandable.dart';
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
          children: Iterable.generate(levelSelectionBloc.levelPackOrder.length)
              .map((levelPackIndex) => LevelPackWidget(
                    levelPack: levelSelectionBloc.levelPacks[
                        levelSelectionBloc.levelPackOrder[levelPackIndex]],
                    expandState: ExpandState(),
                    onLevelSelected: (levelDataIndex) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          levelSelectionBloc.setLevel(
                              levelPackIndex, levelDataIndex);
                          return LevelScreen(
                            levelSequencer: levelSelectionBloc,
                            levelScreenStrings: LevelScreenStrings(
                              title: "Levels",
                              nextLevelTitle: "Level completed!",
                              nextLevelContent: "Play next level?",
                              nextLevelAffirmative: "Yes",
                              nextLevelNegative: "No",
                              noNextLevelTitle: "Level completed!",
                              noNextLevelConfirm: "Ok",
                            ),
                          );
                        },
                      ));
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}

import 'package:flips/main/theme.dart';
import 'package:flips/screen/home/levelDataBloc.dart';
import 'package:flips/screen/home/levelDataSelector.dart';
import 'package:flips/screen/level/levelData.dart';
import 'package:flips/screen/level/levelScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flips"),
      ),
      backgroundColor: flipsTheme.backgroundColor,
      body: LevelDataInheritedWidget(
        levelDataBloc: LevelDataBloc(),
        child: _Home(),
      ),
    );
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final levelDataBloc = LevelDataInheritedWidget.of(context).levelDataBloc;
    return Center(
      child: Column(
        children: [
          Text("Flips",
              style: TextStyle(
                color: flipsTheme.accentColor,
                fontSize: 128.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              )),
          StreamBuilder(
              stream: levelDataBloc.levelDataStream,
              builder:
                  (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
                return FlatButton(
                  child: Text("Play",
                      style: TextStyle(
                          color: flipsTheme.accentColor, fontSize: 32.0)),
                  color: flipsTheme.primaryColor,
                  disabledColor: flipsTheme.disabledColor,
                  onPressed: levelDataBloc.usingAnyCellType()
                      ? () {
                          if (levelDataBloc.usingAnyCellType()) {
                            gotoLevelScreen(
                                context, levelDataBloc.getLevelData());
                          }
                        }
                      : null,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                );
              }),
          LevelDataSelector(),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

  gotoLevelScreen(BuildContext context, LevelData levelData) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LevelScreen(LevelData(
                cellTypes: levelData.cellTypes,
                height: levelData.height,
                width: levelData.width,
              ))),
    );
  }
}

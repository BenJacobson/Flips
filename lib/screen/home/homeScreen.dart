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
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          Text("Flips",
              style: TextStyle(
                color: flipsTheme.accentColor,
                fontSize: 128.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 100),
          FlatButton(
            child: Text("Play",
                style:
                    TextStyle(color: flipsTheme.accentColor, fontSize: 32.0)),
            color: flipsTheme.primaryColor,
            onPressed: () => gotoLevelScreen(context),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          SizedBox(height: 100),
          LevelDataSelector(),
        ],
      ),
    );
  }

  gotoLevelScreen(BuildContext context) {
    LevelData levelData =
        LevelDataInheritedWidget.of(context).levelDataBloc.getLevelData();
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

import 'package:flips/model/level/levelData.dart';
import 'package:flips/screen/level/levelScreen.dart';
import 'package:flips/widget/leveldata/levelDataBloc.dart';
import 'package:flips/widget/leveldata/levelDataSelector.dart';
import 'package:flutter/material.dart';

class FreePlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Free Play"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: LevelDataInheritedWidget(
        levelDataBloc: LevelDataBloc(),
        child: _FreePlayWidget(),
      ),
    );
  }
}

//
class _FreePlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final levelDataBloc = LevelDataInheritedWidget.of(context).levelDataBloc;
    return Column(
      children: [
        Container(
          child: Text(
            "Select the board size and colors",
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 40.0),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        LevelDataSelector(),
        StreamBuilder(
            stream: levelDataBloc.levelDataStream,
            builder: (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
              return FlatButton(
                child: Text("Play",
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 32.0)),
                color: Theme.of(context).primaryColor,
                disabledColor: Theme.of(context).disabledColor,
                onPressed: levelDataBloc.usingAnyCellType()
                    ? () {
                        if (levelDataBloc.usingAnyCellType()) {
                          gotoLevelScreen(
                              context, levelDataBloc.getLevelData());
                        }
                      }
                    : null,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              );
            }),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

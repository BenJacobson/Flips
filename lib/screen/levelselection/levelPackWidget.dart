import 'package:flips/screen/level/levelScreen.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flips/model/leveldata/levelData.dart';
import 'package:flips/model/leveldata/levelPack.dart';
import 'package:flutter/material.dart';

class LevelPackWidget extends StatelessWidget {
  final LevelPack levelPack;

  LevelPackWidget({@required this.levelPack}) {
    assert(levelPack != null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Wrap(
            children: CellType.values
                .where((cellType) => levelPack.usesCellType(cellType))
                .map((cellType) {
                  return Container(
                    color: Cell.colorForType(cellType),
                    height: 40.0,
                    width: 40.0,
                  );
                })
                .cast<Widget>()
                .followedBy([
                  Text(
                    levelPack.width.toString() +
                        "×" +
                        levelPack.height.toString(),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 32.0,
                    ),
                  ),
                ])
                .toList(),
            spacing: 10.0,
            runSpacing: 10.0,
          ),
          SizedBox(
            height: 16.0,
          ),
          Wrap(
            children: Iterable.generate(levelPack.length).map((i) {
              return _LevelDataWidget(
                levelData: levelPack[i],
                displayName: (i + 1).toString(),
              );
            }).toList(),
            spacing: 10.0,
            runSpacing: 10.0,
            alignment: WrapAlignment.spaceBetween,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
      margin: EdgeInsets.all(16.0),
    );
  }
}

class _LevelDataWidget extends StatelessWidget {
  final String displayName;
  final LevelData levelData;

  _LevelDataWidget({this.levelData, this.displayName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text(
          displayName,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 32.0,
          ),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return LevelScreen(
                levelData: levelData,
              );
            },
          ));
        },
      ),
      height: 48.0,
      width: 80.0,
    );
  }
}

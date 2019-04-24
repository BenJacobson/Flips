import 'package:flips/screen/level/levelScreen.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flips/model/leveldata/levelData.dart';
import 'package:flips/model/leveldata/levelPack.dart';
import 'package:flips/widget/animation/expandable.dart';
import 'package:flutter/material.dart';

class LevelPackWidget extends StatelessWidget {
  final LevelPack levelPack;
  final ExpandState expandState;

  LevelPackWidget({
    @required this.levelPack,
    this.expandState,
  }) {
    assert(levelPack != null);
  }

  @override
  Widget build(BuildContext context) {
    return Expandable(
      header: buildHeader(context),
      content: buildLevels(),
      expandState: expandState,
    );
  }

  Widget buildHeader(BuildContext context) {
    return Wrap(
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
              levelPack.width.toString() + "×" + levelPack.height.toString(),
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 32.0,
              ),
            ),
            Text(
              levelPack.numCompleted.toString() +
                  "/" +
                  levelPack.numLevels.toString(),
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 32.0,
              ),
            ),
          ])
          .toList(),
      spacing: 10.0,
      runSpacing: 10.0,
    );
  }

  Widget buildLevels() {
    return Wrap(
      children: Iterable.generate(levelPack.numLevels).map((i) {
        return _LevelDataWidget(
          levelData: levelPack[i],
          displayName: (i + 1).toString(),
        );
      }).toList(),
      spacing: 10.0,
      runSpacing: 10.0,
      alignment: WrapAlignment.spaceBetween,
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
        color: levelData.completed
            ? Theme.of(context).backgroundColor
            : Theme.of(context).primaryColor,
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

import 'package:flips/model/board/cell.dart';
import 'package:flips/model/leveldata/levelData.dart';
import 'package:flips/model/leveldata/levelPack.dart';
import 'package:flips/widget/animation/expandable.dart';
import 'package:flutter/material.dart';

typedef LevelSelectedCallback = void Function(int);

class LevelPackWidget extends StatelessWidget {
  final LevelPack levelPack;
  final ExpandState expandState;
  final LevelSelectedCallback onLevelSelected;

  LevelPackWidget({
    @required this.levelPack,
    this.expandState,
    @required this.onLevelSelected,
  })  : assert(levelPack != null),
        assert(onLevelSelected != null);

  @override
  Widget build(BuildContext context) {
    return Expandable(
      header: buildHeader(context),
      content: buildLevels(),
      expandState: expandState,
    );
  }

  // TODO: cell type widgets will be removed when levels are reorganized into
  // easy, medium, and hard.
  Iterable<Widget> generateCellWidgets(BuildContext context) sync* {
    bool first = true;
    for (final cellType in CellType.values) {
      if (first) {
        first = false;
      } else {
        yield SizedBox(
          width: 10.0,
        );
      }
      Color color = Cell.colorForType(cellType);
      yield Container(
        color: color,
        height: 40.0,
        width: 40.0,
      );
    }
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      children: generateCellWidgets(context).cast<Widget>().followedBy([
        Spacer(),
        Text(
          levelPack.width.toString() + "×" + levelPack.height.toString(),
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 32.0,
          ),
        ),
        Spacer(),
        Text(
          levelPack.numCompleted.toString() +
              "/" +
              levelPack.numLevels.toString(),
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 32.0,
          ),
        ),
      ]).toList(),
    );
  }

  Widget buildLevels() {
    return Wrap(
      children: Iterable.generate(levelPack.numLevels).map((i) {
        return _LevelDataWidget(
          levelData: levelPack[i],
          displayName: (i + 1).toString(),
          onLevelSelected: () => onLevelSelected(i),
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
  final VoidCallback onLevelSelected;

  _LevelDataWidget({
    @required this.levelData,
    @required this.displayName,
    @required this.onLevelSelected,
  });

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
        onPressed: onLevelSelected,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      height: 48.0,
      width: 80.0,
    );
  }
}

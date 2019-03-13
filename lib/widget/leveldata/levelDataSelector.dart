import 'package:flips/global/theme.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flips/model/level/levelData.dart';
import 'package:flips/widget/leveldata/levelDataBloc.dart';
import 'package:flips/screen/home/events.dart';
import 'package:flips/widget/animation/flipWidget.dart';
import 'package:flips/widget/board/shapeWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LevelDataSelector extends StatelessWidget {
  static final double _baseSize = 80.0;
  static final double _iconSize = _baseSize * 0.3;
  static final double _fontSize = _baseSize * 0.4;
  static final double _spacingSize = _baseSize * 0.3;
  final Duration toggleDuration = const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    LevelDataBloc levelDataBloc =
        LevelDataInheritedWidget.of(context).levelDataBloc;
    SchedulerBinding.instance.scheduleFrameCallback(
        (timestamp) => levelDataBloc.eventSink.add(PushEvent()));
    return DropdownButtonHideUnderline(
      child: Column(
        children: [
          Row(
            children: [
              StreamBuilder(
                stream: levelDataBloc.levelDataStream,
                builder:
                    (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
                  int width = snapshot.hasData
                      ? snapshot.data.width
                      : LevelDataBloc.widthOptions.first;
                  return buildNumberSelector(
                      context,
                      "Width",
                      width,
                      (selectedWidth) => levelDataBloc.eventSink
                          .add(WidthEvent(selectedWidth)));
                },
              ),
              SizedBox(
                width: _spacingSize,
              ),
              StreamBuilder(
                stream: levelDataBloc.levelDataStream,
                builder:
                    (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
                  int height = snapshot.hasData
                      ? snapshot.data.height
                      : LevelDataBloc.heightOptions.first;
                  return buildNumberSelector(
                      context,
                      "Height",
                      height,
                      (selectedHeight) => levelDataBloc.eventSink
                          .add(HeightEvent(selectedHeight)));
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            height: _spacingSize,
          ),
          Row(
            children: LevelDataBloc.cellTypeOptions
                .map((cellType) => buildCellTypeSelector(
                      levelDataBloc,
                      cellType,
                    ))
                .toList(),
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }

  Widget buildNumberSelector(
      BuildContext context, String label, int value, ValueChanged onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: flipsTheme.textTheme.subhead.copyWith(
            color: flipsTheme.accentColor,
            fontSize: _fontSize,
          ),
        ),
        SizedBox(
          height: _spacingSize / 2,
        ),
        Container(
          color: flipsTheme.accentColor,
          child: DropdownButton<int>(
            iconSize: _fontSize,
            items: LevelDataBloc.heightOptions.map((item) {
              return DropdownMenuItem<int>(
                child: Container(
                  child: Text(item.toString()),
                  margin: EdgeInsets.only(left: _spacingSize),
                ),
                value: item,
              );
            }).toList(),
            onChanged: onChanged,
            style: flipsTheme.textTheme.subhead.copyWith(
              fontSize: _fontSize,
            ),
            value: value,
          ),
        ),
      ],
    );
  }

  Widget buildCellTypeSelector(LevelDataBloc levelDataBloc, CellType cellType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        child: Center(
          child: StreamBuilder(
              stream: levelDataBloc.levelDataStream,
              builder:
                  (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
                return FlipWidget(
                  child1: Container(
                    color: Cell.colorForType(cellType),
                    height: _baseSize,
                    width: _baseSize,
                  ),
                  child2: Container(
                    child: Center(
                      child: Shape.fromCellType(cellType, _iconSize),
                    ),
                    color: flipsTheme.disabledColor,
                    height: _baseSize,
                    width: _baseSize,
                  ),
                  origin: Offset(_baseSize / 2, _baseSize / 2),
                  flipped: !levelDataBloc.usingCellType(cellType),
                );
              }),
        ),
        height: _baseSize,
        margin: EdgeInsets.only(
          left: _spacingSize / 2,
          right: _spacingSize / 2,
        ),
        width: _baseSize,
      ),
      onTap: () {
        if (levelDataBloc.usingCellType(cellType)) {
          levelDataBloc.eventSink.add(RemoveCellTypeEvent(cellType));
        } else {
          levelDataBloc.eventSink.add(AddCellTypeEvent(cellType));
        }
      },
    );
  }
}

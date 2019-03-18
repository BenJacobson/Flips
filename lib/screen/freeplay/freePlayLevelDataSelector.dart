import 'package:flips/model/board/cell.dart';
import 'package:flips/screen/freeplay/freePlayLevelDataBloc.dart';
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
    FreePlayLevelDataBloc levelDataBloc =
        FreePlayLevelDataInheritedWidget.of(context).levelDataBloc;
    SchedulerBinding.instance.scheduleFrameCallback(
        (timestamp) => levelDataBloc.eventSink.add(PushEvent()));
    return DropdownButtonHideUnderline(
      child: Column(
        children: [
          Row(
            children: [
              StreamBuilder(
                stream: levelDataBloc.levelDataStream,
                builder: (BuildContext context, AsyncSnapshot<void> _) {
                  int width = levelDataBloc.width;
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
                builder: (BuildContext context, AsyncSnapshot<void> _) {
                  int height = levelDataBloc.height;
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
            children: FreePlayLevelDataBloc.cellTypeOptions
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
          style: Theme.of(context).textTheme.subhead.copyWith(
                color: Theme.of(context).accentColor,
                fontSize: _fontSize,
              ),
        ),
        SizedBox(
          height: _spacingSize / 2,
        ),
        Container(
          color: Theme.of(context).accentColor,
          child: DropdownButton<int>(
            iconSize: _fontSize,
            items: FreePlayLevelDataBloc.heightOptions.map((item) {
              return DropdownMenuItem<int>(
                child: Container(
                  child: Text(item.toString()),
                  margin: EdgeInsets.only(left: _spacingSize),
                ),
                value: item,
              );
            }).toList(),
            onChanged: onChanged,
            style: Theme.of(context).textTheme.subhead.copyWith(
                  fontSize: _fontSize,
                ),
            value: value,
          ),
        ),
      ],
    );
  }

  Widget buildCellTypeSelector(
      FreePlayLevelDataBloc levelDataBloc, CellType cellType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        child: Center(
          child: StreamBuilder(
              stream: levelDataBloc.levelDataStream,
              builder: (BuildContext context, AsyncSnapshot<void> _) {
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
                    color: Theme.of(context).disabledColor,
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

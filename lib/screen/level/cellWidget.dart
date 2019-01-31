import 'package:flips/model/board/cell.dart';
import 'package:flips/main/theme.dart';
import 'package:flips/screen/level/boardBloc.dart';
import 'package:flips/screen/level/events.dart';
import 'package:flips/screen/level/shapeWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CellWidget extends StatefulWidget {
  final int i;
  final int j;
  final Animation<double> hintAnimation;

  CellWidget(this.i, this.j, {@required this.hintAnimation});

  @override
  State<StatefulWidget> createState() {
    return _CellState(i, j, hintAnimation: hintAnimation);
  }
}

class _CellState extends State<CellWidget> {
  final int i;
  final int j;
  final Animation<double> hintAnimation;

  bool _flipped = false;
  bool _selected = false;
  bool _showHint = false;

  _CellState(this.i, this.j, {@required this.hintAnimation});

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;

      boardBloc.boardStream.listen((board) {
        bool newFlipped = board.getFlipped(i, j);
        bool newSelected = board.getSelected(i, j);

        if (newFlipped != _flipped) {
          setState(() {
            _flipped = newFlipped;
          });
        }

        if (newSelected != _selected) {
          setState(() {
            _selected = newSelected;
          });
        }
      });

      boardBloc.showHintsStream.listen((newShowHints) {
        if (newShowHints != _showHint) {
          setState(() {
            _showHint = newShowHints;
          });
        }
      });

      hintAnimation.addListener(() {
        if (_selected && _showHint) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
    Color cellColor =
        _flipped ? flipsTheme.accentColor : boardBloc.getColor(i, j);
    if (_selected && _showHint) {
      cellColor =
          Color.lerp(cellColor, flipsTheme.hintColor, hintAnimation.value);
    }
    return GestureDetector(
      child: Container(
        child: Center(
          child: shapeWidget(
            boardBloc.getCellType(i, j),
            boardBloc.getColor(i, j),
          ),
        ),
        color: cellColor,
        height: 50,
        margin: const EdgeInsets.all(2.0),
        width: 50,
      ),
      onTap: () => boardBloc.eventSink.add(FlipEvent(i, j)),
    );
  }

  Shape shapeWidget(CellType cellType, Color color) {
    double height = 15.0, width = 15.0;
    if (cellType == CellType.BLUE) {
      return SquareWidget(
        color: color,
        height: height-2,
        width: width-2,
      );
    } else if (cellType == CellType.GREEN) {
      return PlusWidget(
        color: color,
        height: height,
        width: width,
      );
    } else if (cellType == CellType.RED) {
      return XWidget(
        color: color,
        height: height,
        width: width,
      );
    } else {
      print('Error: shape not found for type.');
      return SquareWidget(
        color: color,
        height: 0.0,
        width: 0.0,
      );
    }
  }
}

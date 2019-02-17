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
  State<StatefulWidget> createState() => _CellState();
}

class _CellState extends State<CellWidget> {
  bool _flipped = false;
  bool _selected = false;
  bool _showHint = false;

  _CellState();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;

      boardBloc.boardStream.listen((board) {
        bool newFlipped = board.getFlipped(widget.i, widget.j);
        bool newSelected = board.getSelected(widget.i, widget.j);

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

      widget.hintAnimation.addListener(() {
        if (_selected && _showHint) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
    Color cellColor = _flipped
        ? flipsTheme.accentColor
        : boardBloc.getColor(widget.i, widget.j);
    if (_selected && _showHint) {
      cellColor = Color.lerp(
          cellColor, flipsTheme.hintColor, widget.hintAnimation.value);
    }
    return GestureDetector(
      child: Container(
        child: Center(
          child: shapeWidget(
            boardBloc.getCellType(widget.i, widget.j),
            boardBloc.getColor(widget.i, widget.j),
          ),
        ),
        color: cellColor,
        height: 50,
        margin: const EdgeInsets.all(2.0),
        width: 50,
      ),
      onTap: () => boardBloc.eventSink.add(FlipEvent(widget.i, widget.j)),
    );
  }

  Shape shapeWidget(CellType cellType, Color color) {
    double height = 15.0, width = 15.0;
    if (cellType == CellType.BLUE) {
      return SquareWidget(
        color: color,
        height: height - 2,
        width: width - 2,
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

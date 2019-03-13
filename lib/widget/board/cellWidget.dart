import 'package:flips/global/theme.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flips/screen/level/boardBloc.dart';
import 'package:flips/screen/level/events.dart';
import 'package:flips/widget/animation/flipWidget.dart';
import 'package:flips/widget/board/shapeWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CellWidget extends StatefulWidget {
  final int i;
  final int j;
  final Animation<double> hintAnimation;
  final double size;

  CellWidget(
    this.i,
    this.j, {
    @required this.hintAnimation,
    @required this.size,
  });

  @override
  State<StatefulWidget> createState() => _CellState();
}

class _CellState extends State<CellWidget> {
  CellType _cellType;
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
        CellType newCellType = boardBloc.getCellType(widget.i, widget.j);
        bool newFlipped = board.getFlipped(widget.i, widget.j);
        bool newSelected = board.getSelected(widget.i, widget.j);

        if (newCellType != _cellType) {
          setState(() {
            _cellType = newCellType;
          });
        }

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
    return GestureDetector(
      child: FlipWidget(
        child1: Container(
          color: lerpHintColor(boardBloc.getColor(widget.i, widget.j)),
          height: widget.size,
          width: widget.size,
        ),
        child2: Container(
          child: Center(
            child: Shape.fromCellType(
                boardBloc.getCellType(widget.i, widget.j), widget.size * 0.3),
          ),
          color: lerpHintColor(flipsTheme.accentColor),
          height: widget.size,
          width: widget.size,
        ),
        origin: Offset(widget.size / 2, widget.size / 2),
        flipped: _flipped,
      ),
      onTap: () => boardBloc.eventSink.add(FlipEvent(widget.i, widget.j)),
    );
  }

  Color lerpHintColor(Color color) {
    if (_selected && _showHint) {
      return Color.lerp(
          color, flipsTheme.hintColor, widget.hintAnimation.value);
    }
    return color;
  }
}

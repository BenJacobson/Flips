import 'package:flips/screen/level/boardBloc.dart';
import 'package:flips/screen/level/events.dart';
import 'package:flips/main/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BoardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BoardState();
  }
}

class _BoardState extends State<BoardWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.linear);

    bool showingHints = false;
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed && showingHints) {
        animationController.forward();
      }
    });

    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
      boardBloc.showHintsStream.listen((showHints) {
        showingHints = showHints;
        if (showHints) {
          animationController.forward();
        } else {
          animationController.reset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
    return Column(
      children: List<Row>.generate(boardBloc.height, (i) {
        return Row(
          children: List<_CellWidget>.generate(boardBloc.width, (j) {
            return _CellWidget(i, j,
                color: boardBloc.getColor(i, j), hintAnimation: animation);
          }),
          mainAxisAlignment: MainAxisAlignment.center,
        );
      }),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class _CellWidget extends StatefulWidget {
  final int i;
  final int j;
  final Color color;
  final Animation<double> hintAnimation;

  _CellWidget(this.i, this.j,
      {@required this.color, @required this.hintAnimation});

  @override
  State<StatefulWidget> createState() {
    return _CellState(i, j, color: color, hintAnimation: hintAnimation);
  }
}

class _CellState extends State<_CellWidget> {
  final int i;
  final int j;
  final Color color;
  final Animation<double> hintAnimation;

  BoardBloc _boardBloc;

  bool _flipped = false;
  bool _selected = false;
  bool _showHint = false;

  _CellState(this.i, this.j,
      {@required this.color, @required this.hintAnimation});

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      _boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;

      _boardBloc.boardStream.listen((board) {
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

      _boardBloc.showHintsStream.listen((newShowHints) {
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
    Color cellColor = _flipped ? flipsTheme.accentColor : color;
    if (_selected && _showHint) {
      cellColor =
          Color.lerp(cellColor, flipsTheme.hintColor, hintAnimation.value);
    }
    return GestureDetector(
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(19.0),
        ),
        color: cellColor,
        height: 50,
        margin: const EdgeInsets.all(2.0),
        width: 50,
      ),
      onTap: () => _boardBloc.eventSink.add(FlipEvent(i, j)),
    );
  }
}


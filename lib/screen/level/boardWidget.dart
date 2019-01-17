import 'package:flutter/material.dart';
import 'package:flips/model/board/board.dart';
import 'package:flips/main/theme.dart';
import 'package:flutter/scheduler.dart';

class _CellState extends State<_CellWidget> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  bool flipped = false;
  bool glowing = false;
  bool showHints = false;
  double glowLevel = 0.0;

  final VoidCallback onPressed;

  _CellState({
    this.onPressed,
  });

  setFlipped(bool newFlipped) {
    if (flipped != newFlipped) {
      setState(() {
        flipped = newFlipped;
      });
    }
  }

  setShowHints(bool newShowHints) {
    if (showHints != newShowHints) {
      setState(() {
        showHints = newShowHints;
      });
    }
  }

  setSelected(bool newSelected) {
    if (glowing != newSelected) {
      setState(() {
        glowing = newSelected;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    animation.addListener(() {
      if (glowLevel != animation.value) {
        setState(() {
          glowLevel = animation.value;
        });
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var cellColor = flipped ? flipsTheme.accentColor : flipsTheme.primaryColor;
    if (glowing && showHints) {
      cellColor = Color.lerp(cellColor, flipsTheme.hintColor, glowLevel);
    }

    return Container(
      child: FlatButton(
        child: null,
        color: cellColor,
        onPressed: onPressed,
        shape: new RoundedRectangleBorder(), // Remove rounded borders.
      ),
      height: 50,
      margin: const EdgeInsets.all(2.0),
      width: 50,
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _CellWidget extends StatefulWidget {
  final _CellState _state;

  _CellWidget({
    onPressed,
  }) : _state = _CellState(
          onPressed: onPressed,
        );

  setFlipped(bool newFlipped) {
    _state.setFlipped(newFlipped);
  }

  setSelected(newSelected) {
    _state.setSelected(newSelected);
  }

  setShowHints(bool newShowHints) {
    _state.setShowHints(newShowHints);
  }

  @override
  State<StatefulWidget> createState() {
    return _state;
  }
}

class BoardWidget extends StatelessWidget {
  static final _width = 6;
  static final _height = 6;

  final _board = Board(_width, _height);
  final VoidCallback onCompleted;
  final List<_CellWidget> cells = List<_CellWidget>();

  BoardWidget({this.onCompleted});

  setShowHints(showHints) {
    cells.forEach((cell) => cell.setShowHints(showHints));
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance
        .scheduleFrameCallback((timestamp) => _board.reset());
    return Column(
      children: List<Row>.generate(_height, (i) {
        return Row(
          children: List<_CellWidget>.generate(_width, (j) {
            final cell = _CellWidget(
              onPressed: () {
                _board.flip(i, j);
                if (_board.isCompleted()) {
                  onCompleted();
                }
              },
            );
            cells.add(cell);
            _board.setListener(i, j, (flipped, selected) {
              cell.setFlipped(flipped);
              cell.setSelected(selected);
            });
            return cell;
          }),
          mainAxisAlignment: MainAxisAlignment.center,
        );
      }),
    );
  }
}

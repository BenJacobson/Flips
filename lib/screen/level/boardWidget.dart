import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flips/model/board/board.dart';
import 'package:flips/main/theme.dart';

class _CellState extends State<_CellWidget> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  bool flipped;
  bool glowing = false;
  bool showHints = false;
  double glowLevel = 0.0;

  final VoidCallback onPressed;

  _CellState({
    this.flipped,
    this.glowing,
    this.onPressed,
  });

  setFlipped(bool newFlipped) {
    if (flipped != newFlipped) {
      setState(() {
        flipped = newFlipped;
      });
    }
  }

  setGlowing(bool newGlowing) {
    if (glowing != newGlowing) {
      setState(() {
        glowing = newGlowing;
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
        onPressed: () {
          setGlowing(!glowing);
          onPressed();
        },
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
    flipped,
    glowing,
    onPressed,
  }) : _state = _CellState(
          flipped: flipped,
          glowing: glowing,
          onPressed: onPressed,
        );

  set flipped(bool newFlipped) {
    _state.setFlipped(newFlipped);
  }

  set glowing(bool glowing) {
    _state.setGlowing(glowing);
  }

  set showHints(bool value) {
    _state.setShowHints(value);
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
    cells.forEach((cell) => cell.showHints = showHints);
  }

  @override
  Widget build(BuildContext context) {
    final solvers = _board.solve();
    solvers.sort((Point<int> a, Point<int> b) {
      if (a.y != b.y) {
        return a.y - b.y;
      }
      return a.x - b.x;
    });
    int solversIndex = 0;
    return Column(
      children: List<Row>.generate(
          _height,
          (i) => Row(
                children: List<_CellWidget>.generate(_width, (j) {
                  bool solves = solversIndex < solvers.length &&
                      solvers[solversIndex].x == j &&
                      solvers[solversIndex].y == i;
                  if (solves) {
                    solversIndex++;
                  }
                  final cell = _CellWidget(
                    flipped: _board.get(i, j),
                    glowing: solves,
                    onPressed: () {
                      _board.flip(i, j);
                      if (_board.isCompleted()) {
                        onCompleted();
                      }
                    },
                  );
                  cells.add(cell);
                  _board.setListener(i, j, (_) => cell.flipped = _);
                  return cell;
                }),
                mainAxisAlignment: MainAxisAlignment.center,
              )),
    );
  }
}

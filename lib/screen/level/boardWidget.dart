import 'package:flutter/material.dart';
import 'package:flips/model/board/board.dart';
import 'package:flips/main/theme.dart';

class _CellState extends State<_CellWidget> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  bool flipped;
  double glowLevel = 0.0;
  bool glowing = false;

  final VoidCallback onPressed;
  final Color glowColor = Color(0xFFF9D77E);

  _CellState({
    this.flipped,
    this.glowing,
    this.onPressed,
  });

  setFlipped(bool newFlipped) {
    setState(() {
      flipped = newFlipped;
    });
  }

  setGlowing(bool newGlowing) {
    setState(() {
      glowing = newGlowing;
    });
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
    if (glowing) {
      cellColor = Color.lerp(cellColor, glowColor, glowLevel);
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
    flipped,
    glowing,
    onPressed,
  }) : _state = _CellState(
          flipped: flipped,
          glowing: glowing,
          onPressed: onPressed,
        );

  setFlipped(bool newFlipped) {
    _state.setFlipped(newFlipped);
  }

  setGlowing(bool glowing) {
    _state.setGlowing(glowing);
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

  BoardWidget({this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Row>.generate(
          _height,
          (i) => Row(
                children: List<_CellWidget>.generate(_width, (j) {
                  final cell = _CellWidget(
                    flipped: _board.get(i, j),
                    glowing: false,
                    onPressed: () => _board.flip(i, j),
                  );
                  _board.setListener(i, j, cell.setFlipped);
                  return cell;
                }),
                mainAxisAlignment: MainAxisAlignment.center,
              )),
    );
  }
}

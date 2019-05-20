import 'package:flips/screen/level/boardBloc.dart';
import 'package:flips/widget/board/cellWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BoardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoardState();
}

class _BoardState extends State<BoardWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  int _lastHeight = 0;
  int _lastWidth = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);

    bool showingHints = false;
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed && showingHints) {
        _animationController.forward();
      }
    });

    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
      _lastHeight = boardBloc.height;
      _lastWidth = boardBloc.width;
      boardBloc.showHintsStream.listen((showHints) {
        showingHints = showHints;
        if (showHints) {
          _animationController.forward();
        } else {
          _animationController.reset();
        }
      });
      boardBloc.boardStream.listen((board) {
        if (_lastHeight != boardBloc.height || _lastWidth != boardBloc.width) {
          setState(() {
            _lastHeight = boardBloc.height;
            _lastWidth = boardBloc.width;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
    return Column(
      children: List.generate(boardBloc.height, (i) {
        return Row(
          children: List.generate(boardBloc.width, (j) {
            return Container(
              child: CellWidget(i, j, hintAnimation: _animation, size: 50.0),
              margin: EdgeInsets.all(2.0),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.center,
        );
      }),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

import 'package:flips/screen/level/boardBloc.dart';
import 'package:flips/screen/level/cellWidget.dart';
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
          children: List<CellWidget>.generate(boardBloc.width, (j) {
            return CellWidget(i, j, hintAnimation: animation);
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

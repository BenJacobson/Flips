import 'package:flips/model/leveldata/levelSequencer.dart';
import 'package:flips/screen/level/boardBloc.dart';
import 'package:flips/screen/level/events.dart';
import 'package:flips/widget/board/boardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LevelScreen extends StatelessWidget {
  final LevelSequencer levelSequencer;
  final LevelScreenStrings levelScreenStrings;

  LevelScreen({
    @required this.levelSequencer,
    @required this.levelScreenStrings,
  })  : assert(levelSequencer != null),
        assert(levelScreenStrings != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(levelScreenStrings.title),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: BoardBlocInheritedWidget(
        boardBloc: BoardBloc(levelSequencer),
        child: _Level(
          levelScreenStrings: levelScreenStrings,
        ),
      ),
    );
  }
}

class _Level extends StatelessWidget {
  final LevelScreenStrings levelScreenStrings;

  _Level({
    @required this.levelScreenStrings,
  }) : assert(levelScreenStrings != null);

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
    boardBloc.boardStream.listen((immutableBoard) {
      if (immutableBoard.isCompleted()) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => buildLevelCompleteDialog(context, boardBloc),
        );
      }
    });
    SchedulerBinding.instance.scheduleFrameCallback(
        (timestamp) => boardBloc.eventSink.add(PushEvent()));
    return Column(
      children: <Widget>[
        BoardWidget(),
        SizedBox(height: 50),
        _ShowHintsWidget(),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget buildLevelCompleteDialog(BuildContext context, BoardBloc boardBloc) {
    if (boardBloc.hasNextLevel()) {
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text(levelScreenStrings.nextLevelNegative),
            onPressed: () {
              Navigator.of(context).pop(); // Pop the dialog.
              Navigator.of(context).pop(); // Pop the level screen.
            },
            textColor: Colors.black,
          ),
          FlatButton(
            child: Text(levelScreenStrings.nextLevelAffirmative),
            onPressed: () {
              Navigator.of(context).pop(); // Pop the dialog.
              boardBloc.eventSink.add(NextLevelEvent());
            },
            textColor: Colors.black,
          ),
        ],
        content: Text(levelScreenStrings.nextLevelContent),
        title: Text(levelScreenStrings.nextLevelTitle),
      );
    } else {
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text(levelScreenStrings.noNextLevelConfirm),
            onPressed: () {
              Navigator.of(context).pop(); // Pop the dialog.
              Navigator.of(context).pop(); // Pop the level screen.
            },
            textColor: Colors.black,
          ),
        ],
        title: Text(levelScreenStrings.noNextLevelTitle),
      );
    }
  }
}

class _ShowHintsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BoardBlocInheritedWidget.of(context).boardBloc.showHintsStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Row(
              children: [
                Switch(
                  onChanged: (newShowHints) =>
                      BoardBlocInheritedWidget.of(context)
                          .boardBloc
                          .eventSink
                          .add(HintsEvent(newShowHints)),
                  value: snapshot.data,
                ),
                Text("Show hints",
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 24)),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            onTap: () => BoardBlocInheritedWidget.of(context)
                .boardBloc
                .eventSink
                .add(HintsEvent(!snapshot.data)),
          );
        }
        return Container();
      },
    );
  }
}

class LevelScreenStrings {
  final String title;
  final String nextLevelTitle;
  final String nextLevelContent;
  final String nextLevelAffirmative;
  final String nextLevelNegative;
  final String noNextLevelTitle;
  final String noNextLevelConfirm;

  LevelScreenStrings({
    @required this.title,
    @required this.nextLevelTitle,
    @required this.nextLevelContent,
    @required this.nextLevelAffirmative,
    @required this.nextLevelNegative,
    @required this.noNextLevelTitle,
    @required this.noNextLevelConfirm,
  })  : assert(title != null),
        assert(nextLevelTitle != null),
        assert(nextLevelContent != null),
        assert(nextLevelAffirmative != null),
        assert(nextLevelNegative != null),
        assert(noNextLevelTitle != null),
        assert(noNextLevelConfirm != null);
}

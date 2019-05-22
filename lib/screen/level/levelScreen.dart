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
  final double iconSize = 36.0;
  final double sideOptionMargin = 10.0;
  final double topBottomOptionMargin = 5.0;

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
        Spacer(),
        BoardWidget(),
        Spacer(),
        buildOptionBar(context, boardBloc),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget buildOptionBar(BuildContext context, BoardBloc boardBloc) {
    return Container(
      child: Row(
        children: <Widget>[
          StreamBuilder(
              stream: boardBloc.historyStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                bool canUndo = snapshot.hasData && snapshot.data.canUndo;
                return IconButton(
                  color: Theme.of(context).accentColor,
                  icon: Icon(Icons.undo),
                  iconSize: iconSize,
                  onPressed: canUndo
                      ? () => boardBloc.eventSink.add(UndoEvent())
                      : null,
                );
              }),
          StreamBuilder(
              stream: boardBloc.historyStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                bool canRedo = snapshot.hasData && snapshot.data.canRedo;
                return IconButton(
                  color: Theme.of(context).accentColor,
                  icon: Icon(Icons.redo),
                  iconSize: iconSize,
                  onPressed: canRedo
                      ? () => boardBloc.eventSink.add(RedoEvent())
                      : null,
                );
              }),
          Spacer(),
          StreamBuilder(
            stream: boardBloc.showHintsStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              bool showHints = snapshot.hasData && snapshot.data;
              return IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(showHints ? Icons.grid_off : Icons.grid_on),
                iconSize: iconSize,
                onPressed: () => BoardBlocInheritedWidget.of(context)
                    .boardBloc
                    .eventSink
                    .add(HintsEvent(!snapshot.data)),
              );
            },
          ),
        ],
      ),
      margin: EdgeInsets.only(
        left: sideOptionMargin,
        top: topBottomOptionMargin,
        right: sideOptionMargin,
        bottom: topBottomOptionMargin,
      ),
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

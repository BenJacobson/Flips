import 'package:flips/model/board/board.dart';
import 'package:flips/model/leveldata/levelData.dart';
import 'package:flips/screen/level/boardBloc.dart';
import 'package:flips/screen/level/events.dart';
import 'package:flips/widget/board/boardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LevelScreen extends StatelessWidget {
  final LevelData levelData;

  LevelScreen({this.levelData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Free Play"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: BoardBlocInheritedWidget(
        boardBloc: BoardBloc(levelData),
        child: _Level(),
      ),
    );
  }
}

class _Level extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
    SchedulerBinding.instance.scheduleFrameCallback(
        (timestamp) => boardBloc.eventSink.add(PushEvent()));
    return Column(
      children: <Widget>[
        BoardWidget(),
        SizedBox(height: 50),
        _ShowHintsWidget(),
        _CompletedDialog(),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

// A dummy widget used only to get a BuildContext for the level completed
// dialog.
class _CompletedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = BoardBlocInheritedWidget.of(context).boardBloc;
    return StreamBuilder(
      stream: boardBloc.boardStream,
      builder: (BuildContext context, AsyncSnapshot<ImmutableBoard> snapshot) {
        if (snapshot.hasData && snapshot.data.isCompleted()) {
          SchedulerBinding.instance
              .scheduleFrameCallback((timestamp) => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) =>
                        buildLevelCompleteDialog(context, boardBloc),
                  ));
        }
        return Container();
      },
    );
  }

  Widget buildLevelCompleteDialog(BuildContext context, BoardBloc boardBloc) {
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(); // Pop the dialog.
            Navigator.of(context).pop(false); // Pop the level screen.
          },
          textColor: Colors.black,
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop(); // Pop the dialog.
            Navigator.of(context).pop(true); // Pop the level screen.
          },
          textColor: Colors.black,
        ),
      ],
      content: Text("Play Again?"),
      title: Text("Level Complete!"),
    );
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

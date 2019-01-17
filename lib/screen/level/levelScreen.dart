import 'package:flips/screen/level/boardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flips/main/theme.dart';

typedef ShowHintsCallback = void Function(bool);

class LevelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final boardWidget = BoardWidget(
      onCompleted: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: buildLevelCompleteDialog,
        );
      },
    );
    final showHintsWidget = _ShowHintsWidget((showHints) {
      boardWidget.setShowHints(showHints);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Level"),
      ),
      backgroundColor: flipsTheme.backgroundColor,
      body: Column(
        children: <Widget>[
          Text("Level 1",
              style: TextStyle(color: flipsTheme.accentColor, fontSize: 32.0)),
          SizedBox(height: 50),
          boardWidget,
          SizedBox(height: 50),
          showHintsWidget,
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Widget buildLevelCompleteDialog(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(); // Pop the dialog.
            Navigator.of(context).pop(); // Pop the level screen.
          },
        ),
      ],
      content: Text("Play Again?"),
      title: Text("Level Complete!"),
    );
  }
}

class _ShowHintsState extends State<_ShowHintsWidget> {
  final ShowHintsCallback showHintsChanged;
  bool _showHints = false;

  _ShowHintsState(this.showHintsChanged);

  _setShowHints(newShowHints) {
    if (newShowHints != _showHints) {
      setState(() {
        _showHints = newShowHints;
        showHintsChanged(_showHints);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Switch(
            onChanged: _setShowHints,
            value: _showHints,
          ),
          Text("Show hints",
              style: TextStyle(color: flipsTheme.accentColor, fontSize: 24)),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      onTap: () => _setShowHints(!_showHints),
    );
  }
}

class _ShowHintsWidget extends StatefulWidget {
  final ShowHintsCallback showHintsChanged;

  _ShowHintsWidget(this.showHintsChanged);

  @override
  State<StatefulWidget> createState() {
    return _ShowHintsState(this.showHintsChanged);
  }
}

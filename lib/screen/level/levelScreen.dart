import 'package:flips/screen/level/boardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flips/main/theme.dart';

class LevelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level"),
      ),
      backgroundColor: flipsTheme.primaryColor,
      body: Column(
        children: <Widget>[
          Text("Level 1", style: TextStyle(color: Colors.white, fontSize: 32.0)),
          SizedBox(height: 50),
          BoardWidget(
            onCompleted: () {
              showDialog(
                context: context,
                builder: buildLevelCompleteDialog,
              );
            },
          ),
          SizedBox(height: 100),
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
          child: Text('Continue'),
          onPressed: () {
            Navigator.of(context).pop(); // Pop the dialog.
            Navigator.of(context).pop(); // Pop the level screen.
          },
        ),
      ],
      content: Text("contents"),
      title: Text("Level Completed!"),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flips/view/boardView.dart';

void main() => runApp(Flips());

class Flips extends StatelessWidget {
  final _title = "Flips";

  @override
  Widget build(BuildContext context) {
    final boardWidget = BoardWidget();
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Column(
          children: [
            boardWidget,
            FlatButton(
              child: Text("Reset"),
              color: Theme.of(context).secondaryHeaderColor,
              onPressed: () => boardWidget.reset(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flips/screen/freeplay/freePlayScreen.dart';
import 'package:flips/screen/home/flipsLogo.dart';
import 'package:flips/screen/levelselection/levelSelectionScreen.dart';
import 'package:flips/screen/tutorial/tutorialScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flips"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Spacer(),
          FlipsLogo(),
          Spacer(),
          Wrap(
            children: [
              FlatButton(
                child: Text("Levels",
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 32.0)),
                color: Theme.of(context).primaryColor,
                disabledColor: Theme.of(context).disabledColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LevelSelectionScreen()));
                },
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              FlatButton(
                child: Text("Free Play",
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 32.0)),
                color: Theme.of(context).primaryColor,
                disabledColor: Theme.of(context).disabledColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FreePlayScreen()));
                },
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ],
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            spacing: 40.0,
          ),
          Spacer(),
          Row(
            children: [
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.help_outline),
                iconSize: 48.0,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TutorialScreen()));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

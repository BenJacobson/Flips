import 'package:flips/global/theme.dart';
import 'package:flips/screen/freeplay/freePlayScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flips"),
      ),
      backgroundColor: flipsTheme.backgroundColor,
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
          Text("Flips",
              style: TextStyle(
                color: flipsTheme.accentColor,
                fontSize: 128.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              )),
          FlatButton(
            child: Text("Free Play",
                style:
                    TextStyle(color: flipsTheme.accentColor, fontSize: 32.0)),
            color: flipsTheme.primaryColor,
            disabledColor: flipsTheme.disabledColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreePlayScreen())
              );
            },
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

}

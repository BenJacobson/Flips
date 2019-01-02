import 'package:flutter/material.dart';
import 'package:flips/screen/level/levelScreen.dart';
import 'package:flips/main/theme.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flips"),
      ),
      backgroundColor: flipsTheme.backgroundColor,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text("Flips",
                style: TextStyle(
                  color: flipsTheme.accentColor,
                  fontSize: 128.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 100),
            FlatButton(
              child: Text("Play",
                  style: TextStyle(color: flipsTheme.accentColor, fontSize: 32.0)),
              color: flipsTheme.primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelScreen()),
                );
              },
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

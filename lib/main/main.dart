import 'package:flips/global/flipsPageTransitionsTheme.dart';
import 'package:flips/screen/home/homeScreen.dart';
import 'package:flutter/material.dart';

// Wrapping the MaterialApp in a Widget allows the ThemeData to hot reload.
class FlipsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        accentColor: Color.fromRGBO(250, 250, 250, 1.0),
        backgroundColor: Color.fromRGBO(10, 20, 40, 1.0),
        disabledColor: Color.fromRGBO(150, 150, 150, 1.0),
        hintColor: Color.fromRGBO(249, 215, 126, 1.0),
        pageTransitionsTheme: FlipsPageTransitionsTheme(),
        primaryColor: Color.fromRGBO(30, 50, 120, 1.0),
      ),
    );
  }
}

void main() => runApp(FlipsApp());

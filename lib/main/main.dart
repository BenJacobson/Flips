import 'package:flips/global/flipsPageTransitionsTheme.dart';
import 'package:flips/screen/home/homeScreen.dart';
import 'package:flutter/material.dart';

// Wrapping the MaterialApp in a Widget allows the ThemeData to hot reload.
class FlipsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      // The color scheme is muted gray/blue with bright popping tile colors.
      theme: ThemeData(
        accentColor: Color.fromRGBO(250, 250, 250, 1.0),
        backgroundColor: Color.fromRGBO(20, 20, 20, 1.0),
        disabledColor: Color.fromRGBO(150, 150, 150, 1.0),
        hintColor: Color.fromRGBO(249, 215, 126, 1.0),
        pageTransitionsTheme: FlipsPageTransitionsTheme(),
        primaryColor: Colors.blueGrey,
      ),
    );
  }
}

void main() => runApp(FlipsApp());

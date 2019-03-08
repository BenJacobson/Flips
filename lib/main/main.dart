import 'package:flips/global/theme.dart';
import 'package:flips/screen/home/homeScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: HomeScreen(),
      theme: flipsTheme,
      title: 'Flips',
    ));

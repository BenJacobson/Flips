import 'package:flutter/material.dart';

import 'dart:math';

abstract class Shape extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

  Shape({
    @required this.color,
    @required this.width,
    @required this.height,
  });
}

class SquareWidget extends Shape {
  SquareWidget({
    @required color,
    @required width,
    @required height,
  }) : super(color: color, height: height, width: width);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: height,
      width: width,
    );
  }
}

class PlusWidget extends Shape {
  final double cellHeight;
  final double cellWidth;

  PlusWidget({
    @required color,
    @required width,
    @required height,
  })  : cellHeight = height / 3,
        cellWidth = width / 3,
        super(color: color, height: height, width: width);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(height: cellHeight, width: cellWidth),
              Container(color: color, height: cellHeight, width: cellWidth),
              Container(height: cellHeight, width: cellWidth),
            ],
          ),
          Row(
            children: [
              Container(color: color, height: cellHeight, width: cellWidth),
              Container(color: color, height: cellHeight, width: cellWidth),
              Container(color: color, height: cellHeight, width: cellWidth)
            ],
          ),
          Row(
            children: [
              Container(height: cellHeight, width: cellWidth),
              Container(color: color, height: cellHeight, width: cellWidth),
              Container(height: cellHeight, width: cellWidth),
            ],
          ),
        ],
      ),
      height: height,
      width: width,
    );
  }
}

class XWidget extends Shape {
  XWidget({
    @required color,
    @required width,
    @required height,
  }) : super(color: color, height: height, width: width);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 4,
      child: PlusWidget(
        color: color,
        height: height,
        width: width,
      ),
    );
  }
}

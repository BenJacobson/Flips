import 'package:flutter/material.dart';

import 'dart:math';

class FlipWidget extends StatefulWidget {
  final Widget child1;
  final Widget child2;
  final Offset origin;
  final bool flipped;

  FlipWidget({
    @required this.child1,
    @required this.child2,
    this.origin,
    this.flipped = false,
  });

  @override
  State<StatefulWidget> createState() => _FlipState();
}

class _FlipState extends State<FlipWidget> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      value: widget.flipped ? 1.0 : 0.0,
      vsync: this,
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget _) {
        return Transform(
          child: animation.value < 0.5 ? widget.child1 : widget.child2,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(animation.value * pi),
          origin: widget.origin,
        );
      },
    );
  }

  @override
  void didUpdateWidget(FlipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flipped) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class FlipsPageTransitionsTheme extends PageTransitionsTheme {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(animation);
    final secondaryOffsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(-1.0, 0.0),
    ).animate(secondaryAnimation);
    return SlideTransition(
      child: SlideTransition(
        child: child,
        position: offsetAnimation,
      ),
      position: secondaryOffsetAnimation,
    );
  }
}

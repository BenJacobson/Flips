import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Expandable extends StatelessWidget {
  final Widget header;
  final Widget content;
  final ExpandState expandState;

  Expandable({
    @required this.header,
    @required this.content,
    expandState,
  }) : expandState = expandState ?? ExpandState();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            child: header,
            behavior: HitTestBehavior.opaque,
            onTap: expandState.toggle,
          ),
          SizedBox(
            height: 16.0,
          ),
          ClipRect(
            child: CustomSingleChildLayout(
              child: content,
              delegate: _ExpandableChildLayoutDelegate(
                expandState: expandState,
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
      margin: EdgeInsets.all(16.0),
    );
  }
}

class _ExpandableChildLayoutDelegate extends SingleChildLayoutDelegate {
  final ExpandState _expandState;

  _ExpandableChildLayoutDelegate({ExpandState expandState})
      : _expandState = expandState,
        super(relayout: expandState);

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, _expandState.getCurrentHeight());
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    _expandState.setExpandHeight(childSize.height);
    return Offset.zero;
  }

  @override
  bool shouldRelayout(_ExpandableChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class ExpandState extends Listenable {
  final int _expandRate;
  final List<VoidCallback> _listeners = List();
  double _currentHeight = 0;
  double _expandHeight = -1;
  bool _expanding = false;

  ExpandState({int expandRate = 25}) : _expandRate = expandRate;

  void setExpandHeight(double value) {
    _expandHeight = value;
  }

  double getCurrentHeight() => _currentHeight;

  bool isExpanding() => _expanding;

  void toggle() {
    _expanding = !_expanding;
    _update();
  }

  void _update() {
    if (_expandHeight == -1) {
      return;
    }

    if (_expanding) {
      if (_currentHeight < _expandHeight) {
        _currentHeight = min(_currentHeight + _expandRate, _expandHeight);
        _callListeners();
        SchedulerBinding.instance
            .scheduleFrameCallback((time) => _update());
      }
    } else {
      if (_currentHeight > 0.0) {
        _currentHeight = max(_currentHeight - _expandRate, 0.0);
        _callListeners();
        SchedulerBinding.instance
            .scheduleFrameCallback((time) => _update());
      }
    }
  }

  void _callListeners() {
    _listeners.forEach((listener) => listener());
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}

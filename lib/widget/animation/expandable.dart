import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Expandable extends StatefulWidget {
  final Widget header;
  final Widget content;

  Expandable({
    @required this.header,
    @required this.content,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExpandableState();
  }
}

class _ExpandableState extends State<Expandable> {
  @override
  Widget build(BuildContext context) {
    final expandState = _ExpandStateListenable(
      rate: 25,
    );
    return Container(
      child: Column(
        children: [
          GestureDetector(
            child: widget.header,
            onTap: expandState.toggle,
          ),
          SizedBox(
            height: 16.0,
          ),
          ClipRect(
            child: CustomSingleChildLayout(
              child: widget.content,
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
  final _ExpandStateListenable expandState;

  _ExpandableChildLayoutDelegate({this.expandState})
      : super(relayout: expandState);

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, expandState.getCurrentHeight());
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    expandState.setExpandHeight(childSize.height);
    return Offset.zero;
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class _ExpandStateListenable extends Listenable {
  final int rate;
  final List<VoidCallback> _listeners = List();
  double _currentHeight = 0;
  double _expandHeight = -1;
  bool _expanding = false;

  _ExpandStateListenable({this.rate = 5});

  void setExpandHeight(double value) {
    _expandHeight = value;
  }

  double getCurrentHeight() => _currentHeight;

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
        _currentHeight = min(_currentHeight + rate, _expandHeight);
        this._callListeners();
        SchedulerBinding.instance
            .scheduleFrameCallback((time) => this._update());
      }
    } else {
      if (_currentHeight > 0.0) {
        _currentHeight = max(_currentHeight - rate, 0.0);
        this._callListeners();
        SchedulerBinding.instance
            .scheduleFrameCallback((time) => this._update());
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

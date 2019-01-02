import 'package:flutter/material.dart';
import 'package:flips/model/board/board.dart';
import 'package:flips/main/theme.dart';

class _CellState extends State<_CellWidget> {
  bool flipped;
  final VoidCallback onPressed;

  _CellState({
    this.flipped,
    this.onPressed,
  });

  setFlipped(bool newFlipped) {
    setState(() {
      flipped = newFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: null,
        color: flipped ? flipsTheme.accentColor : flipsTheme.primaryColor,
        onPressed: onPressed,
        shape: new RoundedRectangleBorder(), // Remove rounded borders.
      ),
      height: 50,
      margin: const EdgeInsets.all(2.0),
      width: 50,
    );
  }
}

class _CellWidget extends StatefulWidget {
  final _CellState _state;

  _CellWidget({
    flipped,
    onPressed,
  }) : _state = _CellState(flipped: flipped, onPressed: onPressed);

  setFlipped(bool newFlipped) {
    _state.setFlipped(newFlipped);
  }

  @override
  State<StatefulWidget> createState() {
    return _state;
  }
}

class BoardWidget extends StatelessWidget {
  static final _width = 6;
  static final _height = 6;

  final _board = Board(_width, _height);
  final VoidCallback onCompleted;

  BoardWidget({this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: new Iterable.generate(_height)
          .map((i) => Row(
                children: new Iterable.generate(_width).map((j) {
                  final cell = _CellWidget(
                    flipped: _board.get(i, j),
                    onPressed: () => _board.flip(i, j),
                  );
                  _board.setListener(i, j, cell.setFlipped);
                  return cell;
                }).toList(),
                mainAxisAlignment: MainAxisAlignment.center,
              ))
          .toList(),
    );
  }
}

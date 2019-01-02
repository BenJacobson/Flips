import 'package:flutter/material.dart';
import 'package:flips/model/board/board.dart';
import 'package:flips/main/theme.dart';

class _CellWidget extends StatelessWidget {
  final bool flipped;
  final VoidCallback onPressed;

  _CellWidget({
    key: Key,
    this.flipped,
    this.onPressed,
  }) : super(key: key);

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

class _BoardState extends State<BoardWidget> {
  static final _width = 6;
  static final _height = 6;

  final _board = Board(_width, _height);
  final VoidCallback onCompleted;

  _BoardState({this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: new Iterable.generate(_height)
          .map((i) => Row(
                children: new Iterable.generate(_width)
                    .map((j) => _CellWidget(
                        key: Key(i.toString() + ' ' + j.toString()),
                        flipped: _board.get(i, j),
                        onPressed: () {
                          setState(() {
                            _board.flip(i, j);
                            if (_board.isCompleted()) {
                              onCompleted();
                            }
                          });
                        }))
                    .toList(),
                mainAxisAlignment: MainAxisAlignment.center,
              ))
          .toList(),
    );
  }
}

class BoardWidget extends StatefulWidget {
  final VoidCallback onCompleted;
  BoardWidget({this.onCompleted});

  @override
  State<StatefulWidget> createState() {
    return _BoardState(onCompleted: onCompleted);
  }
}

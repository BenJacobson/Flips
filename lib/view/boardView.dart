import 'package:flutter/material.dart';
import 'package:flips/controller/board/board.dart';

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
        color: flipped ? Colors.white : Colors.black,
        onPressed: onPressed,
        shape: new RoundedRectangleBorder(), // Remove rounded borders.
      ),
      decoration:
          new BoxDecoration(border: new Border.all(color: Colors.black)),
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
                          });
                        }))
                    .toList(),
                mainAxisAlignment: MainAxisAlignment.center,
              ))
          .toList(),
    );
  }

  reset() {
    setState(() {
      _board.reset();
    });
  }
}

class BoardWidget extends StatefulWidget {

  _BoardState state;

  @override
  State<StatefulWidget> createState() {
    state = _BoardState();
    return state;
  }

  reset() {
    if (state != null) {
      state.reset();
    }
  }
}

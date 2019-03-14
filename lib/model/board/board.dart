import 'package:flips/model/board/cell.dart';
import 'package:flips/model/board/coordinate.dart';
import 'package:flutter/material.dart';

import 'dart:math';

abstract class ImmutableBoard {
  bool getFlipped(int i, int j);

  bool getSelected(int i, int j);

  bool isCompleted();
}

class Board implements ImmutableBoard {
  static final _rng = new Random();
  static const _RESET_ITERATIONS_MIN = 8;
  static const _RESET_ITERATIONS_MAX = 14;

  final int height;
  final int width;

  final Set<CellType> cellTypes;

  List<List<Cell>> _board;

  Board({
    @required this.height,
    @required this.width,
    @required this.cellTypes,
  }) {
    reset();
  }

  Color getColor(int i, int j) => _board[i][j].color;

  bool getFlipped(int i, int j) => _board[i][j].flipped;

  Iterable<Coordinate> getFlips(int i, int j) =>
      _board[i][j].flips(i, j, width, height);

  bool getSelected(int i, int j) => _board[i][j].selected;

  CellType getCellType(int i, int j) => _board[i][j].cellType;

  flip(int iFlip, int jFlip) {
    _board[iFlip][jFlip].selected = !_board[iFlip][jFlip].selected;
    for (Coordinate coord in getFlips(iFlip, jFlip)) {
      if (0 <= coord.i && coord.i < height && 0 <= coord.j && coord.j < width) {
        _board[coord.i][coord.j].flipped = !_board[coord.i][coord.j].flipped;
      }
    }
  }

  reset() {
    _board = List<List<Cell>>.generate(
        height, (_) => List<Cell>.generate(width, (_) => _newRandomCell()));
    final iterations = _RESET_ITERATIONS_MIN +
        _rng.nextInt(_RESET_ITERATIONS_MAX - _RESET_ITERATIONS_MIN);
    for (int rep = 0; rep < iterations; ++rep) {
      int i = _rng.nextInt(height);
      int j = _rng.nextInt(width);
      flip(i, j);
    }
  }

  isCompleted() {
    return _board.every((row) => row.every((cell) => !cell.flipped));
  }

  Cell _newRandomCell() =>
      Cell.fromCellType(cellTypes.elementAt(_rng.nextInt(cellTypes.length)));
}

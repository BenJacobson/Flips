import 'package:flips/model/board/cell.dart';
import 'package:flutter/material.dart';

import 'dart:math';

abstract class ImmutableBoard {
  bool getFlipped(int i, int j);
  bool getSelected(int i, int j);
  bool isCompleted();
}

class Board implements ImmutableBoard {
  static final _rng = new Random();
  static const _RESET_ITERATIONS_MIN = 10;
  static const _RESET_ITERATIONS_MAX = 20;

  final int height;
  final int width;

  final int _flipLow = -1;
  final int _flipHigh = 1;

  final List<List<Cell>> _board;

  Board(this.height, this.width)
      : _board = List<List<Cell>>.generate(
            height, (_) => List<Cell>.generate(width, (_) => BlueCell()));

  Color getColor(int i, int j) => _board[i][j].color;

  bool getFlipped(int i, int j) => _board[i][j].flipped;

  Iterable<int> getFlips(int i, int j) =>
      _board[i][j].flips(i, j, width, height);

  bool getSelected(int i, int j) => _board[i][j].selected;

  flip(int iFlip, int jFlip) {
    _board[iFlip][jFlip].selected = !_board[iFlip][jFlip].selected;
    for (int i = iFlip + _flipLow; i <= iFlip + _flipHigh; ++i) {
      for (int j = jFlip + _flipLow; j <= jFlip + _flipHigh; ++j) {
        if (0 <= i && i < height && 0 <= j && j < width) {
          _board[i][j].flipped = !_board[i][j].flipped;
        }
      }
    }
  }

  reset() {
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
}

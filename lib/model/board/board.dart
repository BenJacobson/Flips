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

  Color getColor(int i, int j) {
    return _board[i][j].color;
  }

  bool getFlipped(int i, int j) {
    return _board[i][j].flipped;
  }

  bool getSelected(int i, int j) {
    return _board[i][j].selected;
  }

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

  /// Solves the game using Gaussian Elimination to determine which cells need
  /// to be selected. Runtime complexity is O(([width] * [height])^3).
  List<Point<int>> solve() {
    int bits = width * height;
    final matrix = List<List<bool>>.generate(
        bits, (i) => List<bool>.generate(bits + 1, (j) => false));

    // Set which cells need to be flipped in the far right column of the matrix.
    for (int i = 0; i < height; ++i) {
      for (int j = 0; j < width; ++j) {
        if (_board[i][j].flipped) {
          int index = _coordsToIndex(i, j);
          matrix[index][bits] = true;
        }
      }
    }

    // Set which cells flip when a given cell is selected. The column represents
    // the selected cell and the row represents the flipped cell.
    for (int iFlip = 0; iFlip < height; ++iFlip) {
      for (int jFlip = 0; jFlip < width; ++jFlip) {
        int selectedIndex = _coordsToIndex(iFlip, jFlip);
        for (int i = iFlip + _flipLow; i <= iFlip + _flipHigh; ++i) {
          for (int j = jFlip + _flipLow; j <= jFlip + _flipHigh; ++j) {
            if (0 <= i && i < height && 0 <= j && j < width) {
              int flippedIndex = _coordsToIndex(i, j);
              matrix[flippedIndex][selectedIndex] = true;
            }
          }
        }
      }
    }

    // Forward elimination.
    for (int j = 0; j < bits; ++j) {
      // Find the next row that has the bit we want set and swap it with the
      // current row.
      for (int i = j; i < bits; ++i) {
        if (matrix[i][j]) {
          for (int k = 0; k <= bits; ++k) {
            bool tmp = matrix[i][k];
            matrix[i][k] = matrix[j][k];
            matrix[j][k] = tmp;
          }
          break;
        }
      }
      // Xor the current row with rows below that have the current bit set.
      for (int i = j + 1; i < bits; ++i) {
        if (matrix[i][j]) {
          for (int k = 0; k <= bits; ++k) {
            matrix[i][k] ^= matrix[j][k];
          }
        }
      }
    }

    // Back substitution.
    for (int i = bits - 1; i >= 0; --i) {
      for (int j = bits - 1; j > i; --j) {
        if (matrix[i][j]) {
          matrix[i][j] ^= matrix[j][j];
          matrix[i][bits] ^= matrix[j][bits];
        }
      }
    }

    final ans = List<Point<int>>();
    for (int i = 0; i < bits; ++i) {
      if (matrix[i][bits]) {
        ans.add(Point(_indexToJCoord(i), _indexToICoord(i)));
      }
    }
    return ans;
  }

  int _coordsToIndex(int i, int j) {
    return i * width + j;
  }

  int _indexToICoord(int index) {
    return index ~/ width;
  }

  int _indexToJCoord(int index) {
    return index % width;
  }
}

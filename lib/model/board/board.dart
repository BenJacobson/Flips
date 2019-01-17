import 'dart:math';

typedef FlippedCallback = void Function(bool, bool);

class _Cell {
  bool flipped;
  bool selected;
  FlippedCallback listener;

  _Cell({this.flipped = false, this.selected = false, this.listener});
}

class Board {
  static final rng = new Random();
  static const RESET_ITERATIONS_MIN = 10;
  static const RESET_ITERATIONS_MAX = 20;

  final _height;
  final _width;

  final _flipLow = -1;
  final _flipHigh = 1;

  final List<List<_Cell>> _board;

  Board(this._height, this._width)
      : _board = List<List<_Cell>>.generate(
            _height, (_) => List<_Cell>.generate(_width, (_) => _Cell()));

  getFlipped(int i, int j) {
    return _board[i][j].flipped;
  }

  setListener(int i, int j, FlippedCallback cb) {
    _board[i][j].listener = cb;
  }

  flip(int iFlip, int jFlip) {
    for (int i = iFlip + _flipLow; i <= iFlip + _flipHigh; ++i) {
      for (int j = jFlip + _flipLow; j <= jFlip + _flipHigh; ++j) {
        if (0 <= i && i < _height && 0 <= j && j < _width) {
          _board[i][j].flipped = !_board[i][j].flipped;
          _board[i][j].selected =
              _board[i][j].selected ^ (i == iFlip && j == jFlip);
          _board[i][j].listener(_board[i][j].flipped, _board[i][j].selected);
        }
      }
    }
  }

  reset() {
    final iterations = RESET_ITERATIONS_MIN +
        rng.nextInt(RESET_ITERATIONS_MAX - RESET_ITERATIONS_MIN);
    for (int rep = 0; rep < iterations; ++rep) {
      int i = rng.nextInt(_height);
      int j = rng.nextInt(_width);
      flip(i, j);
    }
  }

  isCompleted() {
    return _board.every((row) => row.every((cell) => !cell.flipped));
  }

  /// Solves the game using Gaussian Elimination to determine which cells need
  /// to be selected. Runtime complexity is O(([_width] * [_height])^3).
  List<Point<int>> solve() {
    int bits = _width * _height;
    final matrix = List<List<bool>>.generate(
        bits, (i) => List<bool>.generate(bits + 1, (j) => false));

    // Set which cells need to be flipped in the far right column of the matrix.
    for (int i = 0; i < _height; ++i) {
      for (int j = 0; j < _width; ++j) {
        if (_board[i][j].flipped) {
          int index = _coordsToIndex(i, j);
          matrix[index][bits] = true;
        }
      }
    }

    // Set which cells flip when a given cell is selected. The column represents
    // the selected cell and the row represents the flipped cell.
    for (int iFlip = 0; iFlip < _height; ++iFlip) {
      for (int jFlip = 0; jFlip < _width; ++jFlip) {
        int selectedIndex = _coordsToIndex(iFlip, jFlip);
        for (int i = iFlip + _flipLow; i <= iFlip + _flipHigh; ++i) {
          for (int j = jFlip + _flipLow; j <= jFlip + _flipHigh; ++j) {
            if (0 <= i && i < _height && 0 <= j && j < _width) {
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
    return i * _width + j;
  }

  int _indexToICoord(int index) {
    return index ~/ _width;
  }

  int _indexToJCoord(int index) {
    return index % _width;
  }
}

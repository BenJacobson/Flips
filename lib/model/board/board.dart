import 'dart:math';

typedef FlippedCallback = void Function(bool);

class Board {
  static final rng = new Random();
  static const RESET_ITERATIONS = 10;

  final _height;
  final _width;

  final _flipLow = -1;
  final _flipHigh = 1;

  final _board;
  final _listeners;

  Board(this._height, this._width)
      : _board = List<List<bool>>.generate(
            _height, (_) => List<bool>.generate(_width, (_) => false)),
        _listeners = List<List<FlippedCallback>>.generate(_height,
            (_) => List<FlippedCallback>.generate(_width, (_) => (_) {})) {
    reset();
  }

  get(int i, int j) {
    return _board[i][j];
  }

  setListener(int i, int j, FlippedCallback cb) {
    _listeners[i][j] = cb;
  }

  flip(int i, int j) {
    for (int ii = i + _flipLow; ii <= i + _flipHigh; ++ii) {
      for (int jj = j + _flipLow; jj <= j + _flipHigh; ++jj) {
        if (0 <= ii && ii < _height && 0 <= jj && jj < _width) {
          _board[ii][jj] = !_board[ii][jj];
          _listeners[ii][jj](_board[ii][jj]);
        }
      }
    }
  }

  reset() {
    for (int rep = 0; rep < RESET_ITERATIONS; ++rep) {
      int i = rng.nextInt(_height);
      int j = rng.nextInt(_width);
      flip(i, j);
    }
  }

  isCompleted() {
    int total = this._board.fold(0, (acc, row) {
      return acc +
          row.fold(0, (acc, cell) {
            return acc + (cell ? 1 : 0);
          });
    });
    return total == 0 || total == _width * _height;
  }
}

import 'package:flips/model/board/board.dart';
import 'package:flips/model/board/coordinate.dart';

class BoardSolver {
  /// Solves the board using Gaussian Elimination to determine which cells need
  /// to be selected. The runtime complexity is O(([width] * [height])^3).
  static List<Coordinate> solve(Board board) {
    int bits = board.width * board.height;
    final matrix = List<List<bool>>.generate(
        bits, (i) => List<bool>.generate(bits + 1, (j) => false));

    // Set which cells need to be flipped in the far right column of the matrix.
    for (int i = 0; i < board.height; ++i) {
      for (int j = 0; j < board.width; ++j) {
        if (board.getFlipped(i, j)) {
          int index = _coordsToIndex(i, j, board.width);
          matrix[index][bits] = true;
        }
      }
    }

    // Set which cells flip when a given cell is selected. The column represents
    // the selected cell and the row represents the flipped cell.
    for (int iFlip = 0; iFlip < board.height; ++iFlip) {
      for (int jFlip = 0; jFlip < board.width; ++jFlip) {
        int selectedIndex = _coordsToIndex(iFlip, jFlip, board.width);
        for (Coordinate coord in board.getFlips(iFlip, jFlip)) {
          if ((0 <= coord.i && coord.i < board.height) &&
              (0 <= coord.j && coord.j < board.width)) {
            int flippedIndex = _coordsToIndex(coord.i, coord.j, board.width);
            matrix[flippedIndex][selectedIndex] = true;
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

    final ans = List<Coordinate>();
    for (int i = 0; i < bits; ++i) {
      if (matrix[i][bits]) {
        ans.add(Coordinate(
            _indexToJCoord(i, board.width), _indexToICoord(i, board.width)));
      }
    }
    return ans;
  }

  static int _coordsToIndex(int i, int j, int width) => i * width + j;

  static int _indexToICoord(int index, int width) => index ~/ width;

  static int _indexToJCoord(int index, int width) => index % width;
}

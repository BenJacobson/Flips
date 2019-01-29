import 'package:flips/model/board/board.dart';
import 'package:flips/model/board/coordinate.dart';

import 'dart:math';

class BoardSolver {

  /// Solves the board using Gaussian Elimination to determine which cells need
  /// to be selected. The runtime complexity is O(([width] * [height])^3).
  static List<Point<int>> solve(Board board) {
    int bits = board.width * board.height;
    final matrix = List<List<bool>>.generate(
        bits, (i) => List<bool>.generate(bits + 1, (j) => false));

    // Set which cells need to be flipped in the far right column of the matrix.
    for (int i = 0; i < board.height; ++i) {
      for (int j = 0; j < board.width; ++j) {
        if (board.getFlipped(i, j)) {
          int index = Coordinates.coordsToIndex(i, j, board.width);
          matrix[index][bits] = true;
        }
      }
    }

    // Set which cells flip when a given cell is selected. The column represents
    // the selected cell and the row represents the flipped cell.
    for (int iFlip = 0; iFlip < board.height; ++iFlip) {
      for (int jFlip = 0; jFlip < board.width; ++jFlip) {
        int selectedIndex =
            Coordinates.coordsToIndex(iFlip, jFlip, board.width);
        for (int coordinate in board.getFlips(iFlip, jFlip)) {
          int i = Coordinates.indexToICoord(coordinate, board.width);
          int j = Coordinates.indexToJCoord(coordinate, board.width);
          if (0 <= i && i < board.height && 0 <= j && j < board.width) {
            matrix[coordinate][selectedIndex] = true;
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
        ans.add(Point(Coordinates.indexToJCoord(i, board.width),
            Coordinates.indexToICoord(i, board.width)));
      }
    }
    return ans;
  }
}

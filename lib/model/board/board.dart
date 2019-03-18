import 'package:flips/model/board/cell.dart';
import 'package:flips/model/board/coordinate.dart';
import 'package:flips/model/leveldata/levelData.dart';
import 'package:flutter/material.dart';

abstract class ImmutableBoard {
  bool getFlipped(int i, int j);

  bool getSelected(int i, int j);

  bool isCompleted();
}

class Board implements ImmutableBoard {
  List<List<Cell>> _board;

  LevelData levelData;

  Board({
    @required this.levelData,
  }) {
    _board = Iterable.generate(levelData.height).map((i) {
      return Iterable.generate(levelData.width).map((j) {
        return Cell.fromCellType(levelData.getCellType(i, j));
      }).toList();
    }).toList();
    reset();
  }

  int get height => _board.length;

  int get width => height > 0 ? _board[0].length : 0;

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
    for (int i = 0; i < height; ++i) {
      for (int j = 0; j < width; ++j) {
        _board[i][j].selected = false;
        _board[i][j].flipped = false;
      }
    }

    for (int i = 0; i < height; ++i) {
      for (int j = 0; j < width; ++j) {
        if (levelData.getSelected(i, j)) {
          flip(i, j);
        }
      }
    }
  }

  isCompleted() {
    return _board.every((row) => row.every((cell) => !cell.flipped));
  }
}

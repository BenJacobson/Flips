import 'package:flips/model/board/coordinate.dart';
import 'package:flutter/material.dart';

enum CellType {
  BLUE,
  GREEN,
  RED,
}

final cellTypeStringMap = Map<String, CellType>.fromEntries(
    CellType.values.map((cellType) => MapEntry(cellType.toString(), cellType)));

abstract class Cell {
  static Cell fromCellType(CellType cellType) {
    switch (cellType) {
      case CellType.GREEN:
        return GreenCell();
      case CellType.RED:
        return RedCell();
      default:
        return BlueCell();
    }
  }

  static Color colorForType(CellType cellType) {
    switch (cellType) {
      case CellType.GREEN:
        return GreenCell.instance.color;
      case CellType.RED:
        return RedCell.instance.color;
      default:
        return BlueCell.instance.color;
    }
  }

  final String serialized;
  final CellType cellType;
  final Color color;
  bool flipped;
  bool selected;

  Cell({
    @required this.cellType,
    @required this.color,
    this.flipped = false,
    this.selected = false,
    @required this.serialized,
  });

  Iterable<Coordinate> flips(int i, int j, int width, int height);
}

class BlueCell extends Cell {
  static final instance = BlueCell();

  BlueCell({flipped = false, selected = false})
      : super(
          cellType: CellType.BLUE,
          color: Colors.lightBlue,
          flipped: flipped,
          selected: selected,
          serialized: 'B',
        );

  Iterable<Coordinate> flips(
      int iFlip, int jFlip, int width, int height) sync* {
    for (int i = iFlip - 1; i <= iFlip + 1; ++i) {
      for (int j = jFlip - 1; j <= jFlip + 1; ++j) {
        yield Coordinate(i, j);
      }
    }
  }
}

class GreenCell extends Cell {
  static final instance = GreenCell();

  GreenCell({flipped = false, selected = false})
      : super(
          cellType: CellType.GREEN,
          color: Colors.lightGreen,
          flipped: flipped,
          selected: selected,
          serialized: 'G',
        );

  Iterable<Coordinate> flips(
      int iFlip, int jFlip, int width, int height) sync* {
    yield Coordinate(iFlip, jFlip);
    yield Coordinate(iFlip + 1, jFlip);
    yield Coordinate(iFlip - 1, jFlip);
    yield Coordinate(iFlip, jFlip + 1);
    yield Coordinate(iFlip, jFlip - 1);
  }
}

class RedCell extends Cell {
  static final instance = RedCell();

  RedCell({flipped = false, selected = false})
      : super(
          cellType: CellType.RED,
          color: Colors.red,
          flipped: flipped,
          selected: selected,
          serialized: 'R',
        );

  Iterable<Coordinate> flips(
      int iFlip, int jFlip, int width, int height) sync* {
    yield Coordinate(iFlip, jFlip);
    yield Coordinate(iFlip + 1, jFlip + 1);
    yield Coordinate(iFlip - 1, jFlip - 1);
    yield Coordinate(iFlip - 1, jFlip + 1);
    yield Coordinate(iFlip + 1, jFlip - 1);
  }
}

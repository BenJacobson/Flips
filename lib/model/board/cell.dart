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
  static CellType deserializeCellType(String c) {
    assert(c.length == 1);
    switch (c.toUpperCase()) {
      case BlueCell.serialized:
        return CellType.BLUE;
      case GreenCell.serialized:
        return CellType.GREEN;
      case RedCell.serialized:
        return CellType.RED;
    }
    assert(false, "Failed to deserialize cell type: " + c);
    return CellType.BLUE;
  }

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

  final CellType cellType;
  final Color color;
  bool flipped;
  bool selected;

  Cell({
    @required this.cellType,
    @required this.color,
    this.flipped = false,
    this.selected = false,
  });

  Iterable<Coordinate> flips(int i, int j, int width, int height);
}

class BlueCell extends Cell {
  static final instance = BlueCell();
  static const String serialized = 'B';

  BlueCell({flipped = false, selected = false})
      : super(
          cellType: CellType.BLUE,
          color: Colors.lightBlue,
          flipped: flipped,
          selected: selected,
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
  static const String serialized = 'G';

  GreenCell({flipped = false, selected = false})
      : super(
          cellType: CellType.GREEN,
          color: Colors.lightGreen,
          flipped: flipped,
          selected: selected,
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
  static const String serialized = 'R';

  RedCell({flipped = false, selected = false})
      : super(
          cellType: CellType.RED,
          color: Colors.red,
          flipped: flipped,
          selected: selected,
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

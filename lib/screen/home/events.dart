import 'package:flips/model/board/cell.dart';

abstract class LevelDataEvent {}

class AddCellTypeEvent extends LevelDataEvent {
  final CellType cellType;

  AddCellTypeEvent(this.cellType);
}

class RemoveCellTypeEvent extends LevelDataEvent {
  final CellType cellType;

  RemoveCellTypeEvent(this.cellType);
}

class HeightEvent extends LevelDataEvent {
  final int height;

  HeightEvent(this.height);
}

class WidthEvent extends LevelDataEvent {
  final int width;

  WidthEvent(this.width);
}

class PushEvent extends LevelDataEvent {}

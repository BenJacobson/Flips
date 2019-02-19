import 'package:flips/model/board/cell.dart';

class LevelData {
  final Set<CellType> cellTypes;
  final int width;
  final int height;

  LevelData({this.cellTypes, this.height, this.width});
}

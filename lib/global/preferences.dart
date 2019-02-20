import 'package:shared_preferences/shared_preferences.dart';
import 'package:flips/model/board/cell.dart';

class Preferences {
  static const String _FREE_PLAY_BOARD_CELLS = "FREE_PLAY_BOARD_CELLS";
  static const String _FREE_PLAY_BOARD_HEIGHT = "FREE_PLAY_BOARD_HEIGHT";
  static const String _FREE_PLAY_BOARD_WIDTH = "FREE_PLAY_BOARD_WIDTH";

  static Future<Set<CellType>> get freePlayBoardCells async {
    final cellsList = await _getStringList(_FREE_PLAY_BOARD_CELLS);
    if (cellsList == null) {
      return null;
    }
    return Set<CellType>.of(
        cellsList.map((cellTypeString) => cellTypeStringMap[cellTypeString]))
      ..remove(null);
  }

  static set freePlayBoardCells(Set<CellType> cellTypes) => _setStringList(
      _FREE_PLAY_BOARD_CELLS,
      cellTypes.map((cellType) => cellType.toString()).toList());

  static Future<int> get freePlayBoardHeight =>
      _getInt(_FREE_PLAY_BOARD_HEIGHT);
  static set freePlayBoardHeight(int value) =>
      _setInt(_FREE_PLAY_BOARD_HEIGHT, value);

  static Future<int> get freePlayBoardWidth => _getInt(_FREE_PLAY_BOARD_WIDTH);
  static set freePlayBoardWidth(int value) =>
      _setInt(_FREE_PLAY_BOARD_WIDTH, value);

  static Future<int> _getInt(String key) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getInt(key);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> _setInt(String key, int value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(key, value);
  }

  static Future<List<String>> _getStringList(String key) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getStringList(key);
    } catch (e) {
      return List();
    }
  }

  static Future<bool> _setStringList(String key, List<String> value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setStringList(key, value);
  }
}

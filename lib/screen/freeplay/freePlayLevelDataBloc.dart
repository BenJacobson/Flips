import 'package:flips/global/preferences.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flips/model/leveldata/levelData.dart';
import 'package:flips/screen/home/events.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math';

class FreePlayLevelDataBloc {
  static final _rng = new Random();
  static const List<CellType> cellTypeOptions = const [
    CellType.BLUE,
    CellType.GREEN,
    CellType.RED,
  ];
  static const List<int> heightOptions = const [4, 5, 6];
  static const List<int> widthOptions = const [4, 5, 6];

  Set<CellType> _cellTypes = Set<CellType>.of(cellTypeOptions);
  int _height = heightOptions.first;
  int _width = widthOptions.first;

  int get height => _height;
  int get width => _width;

  final _levelDataStreamController = StreamController<void>.broadcast();

  Sink<void> get _levelDataSink => _levelDataStreamController.sink;

  Stream<void> get levelDataStream => _levelDataStreamController.stream;

  final _eventStreamController = StreamController<LevelDataEvent>();

  Sink<LevelDataEvent> get eventSink => _eventStreamController.sink;

  Stream<LevelDataEvent> get _eventStream => _eventStreamController.stream;

  FreePlayLevelDataBloc() {
    _eventStream.listen(_transform);
    _loadPreferences();
  }

  _loadPreferences() async {
    final cellTypes = await Preferences.freePlayBoardCells;
    final height = await Preferences.freePlayBoardHeight;
    final width = await Preferences.freePlayBoardWidth;
    if (cellTypes != null) {
      _cellTypes = cellTypes;
    }
    if (height != null) {
      _height = height;
    }
    if (width != null) {
      _width = width;
    }
    eventSink.add(PushEvent());
  }

  _transform(LevelDataEvent event) {
    if (event is AddCellTypeEvent) {
      _cellTypes.add(event.cellType);
      Preferences.freePlayBoardCells = _cellTypes;
    } else if (event is RemoveCellTypeEvent) {
      _cellTypes.remove(event.cellType);
      Preferences.freePlayBoardCells = _cellTypes;
    } else if (event is HeightEvent) {
      _height = event.height;
      Preferences.freePlayBoardHeight = _height;
    } else if (event is WidthEvent) {
      _width = event.width;
      Preferences.freePlayBoardWidth = _width;
    } else if (event is PushEvent) {
      // Let the data flow.
    } else {
      print("Error: Unknown event received in LevelDataBloc.");
    }
    _levelDataSink.add(null);
  }

  LevelData getLevelData() {
    int fraction = _rng.nextInt(3) + 2;
    return LevelData(
      cells: Iterable.generate(_height).map((i) {
        return Iterable.generate(_width).map((j) {
          return LevelCell(
            cellType: _randomCellType(),
            selected: _rng.nextInt(fraction) == 0,
          );
        }).toList();
      }).toList(),
    );
  }

  CellType _randomCellType() =>
      _cellTypes.elementAt(_rng.nextInt(_cellTypes.length));

  bool usingCellType(CellType cellType) => _cellTypes.contains(cellType);

  bool usingAnyCellType() => _cellTypes.length > 0;

  close() {
    _levelDataStreamController.close();
    _eventStreamController.close();
  }
}

class FreePlayLevelDataInheritedWidget extends InheritedWidget {
  final FreePlayLevelDataBloc levelDataBloc;

  FreePlayLevelDataInheritedWidget(
      {@required this.levelDataBloc, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FreePlayLevelDataInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(FreePlayLevelDataInheritedWidget);
}

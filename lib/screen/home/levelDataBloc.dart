import 'package:flips/model/board/cell.dart';
import 'package:flips/screen/home/events.dart';
import 'package:flips/screen/level/levelData.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class LevelDataBloc {
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

  final _levelDataStreamController = StreamController<LevelData>();
  Sink<LevelData> get _levelDataSink => _levelDataStreamController.sink;
  Stream<LevelData> get levelDataStream => _levelDataStreamController.stream;

  final _eventStreamController = StreamController<LevelDataEvent>();
  Sink<LevelDataEvent> get eventSink => _eventStreamController.sink;
  Stream<LevelDataEvent> get _eventStream => _eventStreamController.stream;

  LevelDataBloc() {
    _eventStream.listen(_transform);
  }

  _transform(LevelDataEvent event) {
    if (event is AddCellTypeEvent) {
      _cellTypes.add(event.cellType);
    } else if (event is RemoveCellTypeEvent) {
      _cellTypes.remove(event.cellType);
    } else if (event is HeightEvent) {
      _height = event.height;
    } else if (event is WidthEvent) {
      _width = event.width;
    } else if (event is PushEvent) {
      // Let the data flow.
    } else {
      print("Error: Unknown event received in LevelDataBloc.");
    }
    _levelDataSink.add(getLevelData());
  }

  LevelData getLevelData() {
    return LevelData(
      cellTypes: _cellTypes,
      height: _height,
      width: _width,
    );
  }

  dispose() {
    _levelDataStreamController.close();
    _eventStreamController.close();
  }
}

class LevelDataInheritedWidget extends InheritedWidget {
  final LevelDataBloc levelDataBloc;

  LevelDataInheritedWidget(
      {@required this.levelDataBloc, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LevelDataInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(LevelDataInheritedWidget);
}

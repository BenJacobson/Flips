import 'package:flips/model/board/board.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flips/screen/level/events.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class BoardBloc {
  final Board _board = Board(6, 6);
  int get width => _board.width;
  int get height => _board.height;

  bool _showHints = false;

  final _boardEventController = StreamController<BoardEvent>();
  StreamSink<BoardEvent> get eventSink => _boardEventController.sink;
  Stream<BoardEvent> get _eventStream => _boardEventController.stream;

  final _immutableBoardStreamController =
      StreamController<ImmutableBoard>.broadcast();
  StreamSink<ImmutableBoard> get _boardSink =>
      _immutableBoardStreamController.sink;
  Stream<ImmutableBoard> get boardStream =>
      _immutableBoardStreamController.stream;

  final _showHintsStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get _showHintsSink => _showHintsStreamController.sink;
  Stream<bool> get showHintsStream => _showHintsStreamController.stream;

  BoardBloc() {
    _eventStream.listen(_transform);
  }

  Color getColor(int i, int j) => _board.getColor(i, j);

  CellType getCellType(int i, int j) => _board.getCellType(i, j);

  _transform(BoardEvent event) {
    if (event is FlipEvent) {
      _board.flip(event.i, event.j);
      _boardSink.add(_board);
    } else if (event is HintsEvent) {
      _showHints = event.showHints;
      _showHintsSink.add(_showHints);
    } else if (event is PushEvent) {
      _showHintsSink.add(_showHints);
      _boardSink.add(_board);
    } else if (event is ResetEvent) {
      _showHints = false;
      _showHintsSink.add(_showHints);
      _board.reset();
      _boardSink.add(_board);
    } else {
      print("Error: unknown board event received");
    }
  }

  void dispose() {
    _boardEventController.close();
    _immutableBoardStreamController.close();
    _showHintsStreamController.close();
  }
}

class BoardBlocInheritedWidget extends InheritedWidget {
  final BoardBloc boardBloc;

  BoardBlocInheritedWidget({@required this.boardBloc, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BoardBlocInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(BoardBlocInheritedWidget);
}

import 'package:flips/model/board/board.dart';
import 'package:flips/model/board/cell.dart';
import 'package:flips/model/leveldata/levelSequencer.dart';
import 'package:flips/screen/level/events.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:collection';

class BoardBloc {
  static const int MAX_HISTORY_LENGTH = 100;

  final Board _board;
  final LevelSequencer _levelSequencer;
  final Queue<FlipEvent> _moveHistory = Queue();
  final _boardEventController = StreamController<BoardEvent>();
  final _historyStreamController = StreamController<HistoryState>.broadcast();
  final _immutableBoardStreamController =
      StreamController<ImmutableBoard>.broadcast();
  final _showHintsStreamController = StreamController<bool>.broadcast();
  bool _showHints = false;
  int _moveHistoryIndex = 0;

  StreamSink<BoardEvent> get eventSink => _boardEventController.sink;

  Stream<BoardEvent> get _eventStream => _boardEventController.stream;

  StreamSink<HistoryState> get _historySink => _historyStreamController.sink;

  Stream<HistoryState> get historyStream => _historyStreamController.stream;

  StreamSink<ImmutableBoard> get _boardSink =>
      _immutableBoardStreamController.sink;

  Stream<ImmutableBoard> get boardStream =>
      _immutableBoardStreamController.stream;

  StreamSink<bool> get _showHintsSink => _showHintsStreamController.sink;

  Stream<bool> get showHintsStream => _showHintsStreamController.stream;

  int get width => _board.width;

  int get height => _board.height;

  String get currentDisplayName =>
      _levelSequencer.getCurrentLevel().displayName;

  BoardBloc(LevelSequencer levelSequencer)
      : _board = Board(
          levelData: levelSequencer.getCurrentLevel(),
        ),
        _levelSequencer = levelSequencer {
    _eventStream.listen(_transform);
  }

  Color getColor(int i, int j) => _board.getColor(i, j);

  CellType getCellType(int i, int j) => _board.getCellType(i, j);

  bool hasNextLevel() => _levelSequencer.hasNextLevel();

  _transform(BoardEvent event) {
    if (event is FlipEvent) {
      _board.flip(event.i, event.j);
      _boardSink.add(_board);
      if (_board.isCompleted()) {
        _board.levelData.setCompleted(true);
      }
      while (_moveHistory.length > _moveHistoryIndex) {
        _moveHistory.removeLast();
      }
      _moveHistory.addLast(event);
      while (_moveHistory.length > MAX_HISTORY_LENGTH) {
        _moveHistory.removeFirst();
      }
      _moveHistoryIndex = _moveHistory.length;
      _historySink.add(HistoryState(
        canRedo: _moveHistoryIndex < _moveHistory.length,
        canUndo: _moveHistoryIndex > 0,
      ));
    } else if (event is HintsEvent) {
      _showHints = event.showHints;
      _showHintsSink.add(_showHints);
    } else if (event is NextLevelEvent) {
      _showHints = false;
      _showHintsSink.add(_showHints);
      _board.loadLevelData(_levelSequencer.getNextLevel());
      _boardSink.add(_board);
      _moveHistory.clear();
      _moveHistoryIndex = 0;
      _historySink.add(HistoryState(
        canRedo: _moveHistoryIndex < _moveHistory.length,
        canUndo: _moveHistoryIndex > 0,
      ));
    } else if (event is PushEvent) {
      _showHintsSink.add(_showHints);
      _boardSink.add(_board);
      _historySink.add(HistoryState(
        canRedo: _moveHistoryIndex < _moveHistory.length,
        canUndo: _moveHistoryIndex > 0,
      ));
    } else if (event is RedoEvent) {
      assert(_moveHistoryIndex < _moveHistory.length);
      FlipEvent event = _moveHistory.elementAt(_moveHistoryIndex);
      _board.flip(event.i, event.j);
      _boardSink.add(_board);
      _moveHistoryIndex++;
      _historySink.add(HistoryState(
        canRedo: _moveHistoryIndex < _moveHistory.length,
        canUndo: _moveHistoryIndex > 0,
      ));
    } else if (event is ResetEvent) {
      _showHints = false;
      _showHintsSink.add(_showHints);
      _board.reset();
      _boardSink.add(_board);
      _moveHistory.clear();
      _moveHistoryIndex = 0;
      _historySink.add(HistoryState(
        canRedo: _moveHistoryIndex < _moveHistory.length,
        canUndo: _moveHistoryIndex > 0,
      ));
    } else if (event is UndoEvent) {
      assert(_moveHistoryIndex > 0);
      _moveHistoryIndex--;
      FlipEvent event = _moveHistory.elementAt(_moveHistoryIndex);
      _board.flip(event.i, event.j);
      _boardSink.add(_board);
      _historySink.add(HistoryState(
        canRedo: _moveHistoryIndex < _moveHistory.length,
        canUndo: _moveHistoryIndex > 0,
      ));
    } else {
      print("Error: unknown board event received");
    }
  }

  void close() {
    _boardEventController.close();
    _historyStreamController.close();
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

class HistoryState {
  final bool canRedo;
  final bool canUndo;

  HistoryState({
    @required this.canRedo,
    @required this.canUndo,
  })  : assert(canRedo != null),
        assert(canUndo != null);
}

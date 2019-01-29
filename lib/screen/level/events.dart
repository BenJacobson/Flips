abstract class BoardEvent {}

class FlipEvent extends BoardEvent {
  final int i;
  final int j;

  FlipEvent(this.i, this.j);
}

class HintsEvent extends BoardEvent {
  final bool showHints;

  HintsEvent(this.showHints);
}

class PushEvent extends BoardEvent {}

class ResetEvent extends BoardEvent {}

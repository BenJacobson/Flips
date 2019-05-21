import 'package:flips/model/leveldata/levelData.dart';

abstract class LevelSequencer {
  // Returns the current level.
  LevelData getCurrentLevel();

  // Advances to the next level and returns the new level.
  LevelData getNextLevel();

  // Whether there is a next level.
  bool hasNextLevel();
}

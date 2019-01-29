class Coordinates {
  static int coordsToIndex(int i, int j, int width) => i * width + j;
  static int indexToICoord(int index, int width) => index ~/ width;
  static int indexToJCoord(int index, int width) => index % width;
}

extension Approximation on num {
  bool get isWhole => this is int || this == roundToDouble();

  String get leanString => isWhole ? '${toInt()}' : toStringAsFixed(2);
}

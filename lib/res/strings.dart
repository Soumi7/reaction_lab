enum Difficulty { easy, medium, hard }

extension ParseToString on Difficulty {
  String parseToString() {
    return this.toString().split('.').last;
  }
}

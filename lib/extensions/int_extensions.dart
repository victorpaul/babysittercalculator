extension IntExtension on int {
  String minutesToFriendlyTime() {
    final hours = (this ~/ 60).toString().padLeft(2, "0");
    final minutes = (this % 60).toString().padLeft(2, "0");
    return "$hours:$minutes";
  }

  Duration minutesToDuration() {

    return Duration(minutes: this);
  }
}

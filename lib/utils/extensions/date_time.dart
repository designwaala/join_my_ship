extension DateTimeExt on DateTime {
  String getServerDate() {
    return "$year-$month-$day";
  }
}

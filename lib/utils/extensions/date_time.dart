extension DateTimeExt on DateTime {
  String getServerDate() {
    String formattedDay = day <= 9 ? "0$day" : "$day";
    String formattedMonth = month <= 9 ? "0$month" : "$month";
    return "$year-$formattedMonth-$formattedDay";
  }
}

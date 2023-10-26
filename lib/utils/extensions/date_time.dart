extension DateTimeExt on DateTime {
  String getServerDate() {
    String formattedDay = day <= 9 ? "0$day" : "$day";
    String formattedMonth = month <= 9 ? "0$month" : "$month";
    return "$formattedDay-$formattedMonth-$year";
  }
}

extension ConvertToServer on String {
  String convertDateToYYYYMMDD() {
    return split("-").reversed.join("-");
  }

  String convertDateToDDMMYYY() {
    return split("-").reversed.join("-");
  }
}

extension DaoubleExt on double {
  num get toIntIfZero => this == 0.0 ? 0 : this;
}

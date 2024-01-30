import 'package:intl/intl.dart';

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

extension GetFormattedString on DateTime {
  String getFirebaseString() {
    return DateFormat("MMMM d, yyyy 'at' H:mm:ss aa 'UTC+5:30'").format(this);
  }

  String getCompactDisplayTime() {
    return DateFormat("h:mm a").format(this);
  }

  String getServerDateTime() {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(this);
  }

  String getCompactDisplayDate() {
    return DateFormat("MMMM d, yyyy").format(this);
  }

  String getCompactServerDate() {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  String formatDeliveryDate() {
    return DateFormat("d MMM, EEEE").format(this);
  }

  String formattedDeliveryDate() {
    String day = DateFormat('d').format(this);

    String suffix;
    if(day.endsWith('1') && day != '11'){
      suffix = 'st';
    }else if(day.endsWith('2') && day != '12'){
      suffix = 'nd';
    }else if(day.endsWith('3') && day != '13'){
      suffix = 'rd';
    }else{
      suffix = 'th';
    }
    return DateFormat("EEEE, d'$suffix' MMM.").format(this);
  }
}

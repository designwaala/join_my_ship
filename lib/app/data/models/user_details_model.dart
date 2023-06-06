import 'dart:convert';

class UserDetails {
  int? userId;
  String? iNDOSNumber;
  String? cDCNumber;
  String? cDCNumberValidTill;
  String? cDCSeamanBookNumber;
  String? cDCSeamanBookNumberValidTill;
  String? passportNumber;
  String? passportNumberValidTill;
  List<IssuingAuthority>? sTCWIssuingAuthority;
  List<IssuingAuthority>? validCOCIssuingAuthority;
  List<IssuingAuthority>? validCOPIssuingAuthority;
  List<IssuingAuthority>? validWatchKeepingIssuingAuthority;
  bool? validUSVisa;
  String? validUSVisaValidTill;

  UserDetails(
      {this.userId,
      this.iNDOSNumber,
      this.cDCNumber,
      this.cDCNumberValidTill,
      this.cDCSeamanBookNumber,
      this.cDCSeamanBookNumberValidTill,
      this.passportNumber,
      this.passportNumberValidTill,
      this.sTCWIssuingAuthority,
      this.validCOCIssuingAuthority,
      this.validCOPIssuingAuthority,
      this.validWatchKeepingIssuingAuthority,
      this.validUSVisa,
      this.validUSVisaValidTill});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    iNDOSNumber = json['INDOS_number'];
    cDCNumber = json['CDC_number'];
    cDCNumberValidTill = json['CDC_number_valid_till'];
    cDCSeamanBookNumber = json['CDC_seaman_book'];
    cDCNumberValidTill = json['CDC_seaman_book_valid_till'];
    passportNumber = json['Passport_number'];
    passportNumberValidTill = json['Passport_number_valid_till'];
    sTCWIssuingAuthority = json['STCW_Issuing_Authority'] == null
        ? null
        : List<IssuingAuthority>.from(jsonDecode(json['STCW_Issuing_Authority'])
            ?.map((e) => IssuingAuthority.fromJson(e)));
    validCOCIssuingAuthority = json['valid_COC_Issuing_Authority'] == null ||
            jsonDecode(json['valid_COC_Issuing_Authority']) is! Map
        ? null
        : List<IssuingAuthority>.from(
            jsonDecode(json['valid_COC_Issuing_Authority'])
                ?.map((e) => IssuingAuthority.fromJson(e)));
    validCOPIssuingAuthority = json['valid_COP_Issuing_Authority'] == null ||
            jsonDecode(json['valid_COP_Issuing_Authority']) is! Map
        ? null
        : List<IssuingAuthority>.from(
            jsonDecode(json['valid_COP_Issuing_Authority'])
                ?.map((e) => IssuingAuthority.fromJson(e)));
    validWatchKeepingIssuingAuthority =
        json['valid_Watch_keeping_Issuing_Authority'] == null ||
                jsonDecode(json['valid_Watch_keeping_Issuing_Authority'])
                    is! Map
            ? null
            : List<IssuingAuthority>.from(
                jsonDecode(json['valid_Watch_keeping_Issuing_Authority'])
                    ?.map((e) => IssuingAuthority.fromJson(e)));
    validUSVisa = json['valid_US_Visa'];
    validUSVisaValidTill = json['valid_US_Visa_valid_till'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['INDOS_number'] = iNDOSNumber;
    data['CDC_number'] = cDCNumber;
    data['CDC_number_valid_till'] = cDCNumberValidTill;
    data['CDC_seaman_book'] = cDCSeamanBookNumber;
    data['CDC_seaman_book_valid_till'] = cDCSeamanBookNumberValidTill;
    data['Passport_number'] = passportNumber;
    data['Passport_number_valid_till'] = passportNumberValidTill;
    data['STCW_Issuing_Authority'] =
        sTCWIssuingAuthority?.map((e) => e.toJson()).toList();
    data['valid_COC_Issuing_Authority'] =
        validCOCIssuingAuthority?.map((e) => e.toJson()).toList();
    data['valid_COP_Issuing_Authority'] =
        validCOPIssuingAuthority?.map((e) => e.toJson()).toList();
    data['valid_Watch_keeping_Issuing_Authority'] =
        validWatchKeepingIssuingAuthority?.map((e) => e.toJson()).toList();
    data['valid_US_Visa'] = validUSVisa;
    data['valid_US_Visa_valid_till'] = validUSVisaValidTill;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class IssuingAuthority {
  String? issuingAuthority;
  String? validTill;

  IssuingAuthority({this.issuingAuthority, this.validTill});

  factory IssuingAuthority.fromJson(Map<String, dynamic> json) {
    return IssuingAuthority(
        issuingAuthority: json['issuing_authority'],
        validTill: json['valid_till']);
  }

  Map<String, dynamic> toJson() =>
      {"issuing_authority": issuingAuthority, "valid_till": validTill};
}

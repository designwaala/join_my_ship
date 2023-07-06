import 'dart:convert';

class UserDetails {
  int? id;
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
      {this.id,
      this.userId,
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
    id = json['id'];
    userId = json['user_id'];
    iNDOSNumber = json['INDOS_number'];
    cDCNumber = json['CDC_number'];
    cDCNumberValidTill = json['CDC_number_valid_till'];
    cDCSeamanBookNumber = json['CDC_seaman_book'];
    cDCSeamanBookNumberValidTill = json['CDC_seaman_book_valid_till'];
    passportNumber = json['Passport_number'];
    passportNumberValidTill = json['Passport_number_valid_till'];
    sTCWIssuingAuthority = json['STCW_Issuing_Authority'] == null ||
            json['STCW_Issuing_Authority'] == ""
        ? null
        : (jsonDecode(json['STCW_Issuing_Authority']) is Map<String, dynamic>
            ? [
                IssuingAuthority.fromJson(
                    jsonDecode(json['STCW_Issuing_Authority']))
              ]
            : List<IssuingAuthority>.from(
                jsonDecode(json['STCW_Issuing_Authority'])
                    ?.map((e) => IssuingAuthority.fromJson(e))));
    validCOCIssuingAuthority = json['valid_COC_Issuing_Authority'] == null ||
            json['valid_COC_Issuing_Authority'] == ""
        ? null
        : (jsonDecode(json['valid_COC_Issuing_Authority']))
                is Map<String, dynamic>
            ? [IssuingAuthority.fromJson(json['valid_COC_Issuing_Authority'])]
            : List<IssuingAuthority>.from(
                jsonDecode(json['valid_COC_Issuing_Authority'])
                    ?.map((e) => IssuingAuthority.fromJson(e)));
    validCOPIssuingAuthority = json['valid_COP_Issuing_Authority'] == null ||
            json['valid_COP_Issuing_Authority'] == ""
        ? null
        : (jsonDecode(json['valid_COP_Issuing_Authority']))
                is Map<String, dynamic>
            ? [IssuingAuthority.fromJson(json['valid_COP_Issuing_Authority'])]
            : List<IssuingAuthority>.from(
                jsonDecode(json['valid_COP_Issuing_Authority'])
                    ?.map((e) => IssuingAuthority.fromJson(e)));
    validWatchKeepingIssuingAuthority =
        json['valid_Watch_keeping_Issuing_Authority'] == null ||
                json['valid_Watch_keeping_Issuing_Authority'] == ""
            ? null
            : jsonDecode(json['valid_Watch_keeping_Issuing_Authority'])
                    is Map<String, dynamic>
                ? [
                    IssuingAuthority.fromJson(
                        json['valid_Watch_keeping_Issuing_Authority'])
                  ]
                : List<IssuingAuthority>.from(
                    jsonDecode(json['valid_Watch_keeping_Issuing_Authority'])
                        ?.map((e) => IssuingAuthority.fromJson(e)));
    validUSVisa = json['valid_US_Visa'];
    validUSVisaValidTill = json['valid_US_Visa_valid_till'];
  }

  Map<String, String> toJson() {
    final data = <String, String?>{};
    data['id'] = id?.toString();
    data['user_id'] = userId?.toString();
    data['INDOS_number'] = iNDOSNumber?.toString();
    data['CDC_number'] = cDCNumber?.toString();
    data['CDC_number_valid_till'] = cDCNumberValidTill?.toString();
    data['CDC_seaman_book'] = cDCSeamanBookNumber?.toString();
    data['CDC_seaman_book_valid_till'] =
        cDCSeamanBookNumberValidTill?.toString();
    data['Passport_number'] = passportNumber?.toString();
    data['Passport_number_valid_till'] = passportNumberValidTill.toString();
    data['STCW_Issuing_Authority'] = sTCWIssuingAuthority == null
        ? jsonEncode([])
        : jsonEncode(sTCWIssuingAuthority?.map((e) => e.toJson()).toList());
    data['valid_COC_Issuing_Authority'] = validCOCIssuingAuthority == null
        ? jsonEncode([])
        : jsonEncode(validCOCIssuingAuthority?.map((e) => e.toJson()).toList());
    data['valid_COP_Issuing_Authority'] = validCOPIssuingAuthority == null
        ? jsonEncode([])
        : jsonEncode(validCOPIssuingAuthority?.map((e) => e.toJson()).toList());
    data['valid_Watch_keeping_Issuing_Authority'] =
        validWatchKeepingIssuingAuthority == null
            ? jsonEncode([])
            : jsonEncode(validWatchKeepingIssuingAuthority
                ?.map((e) => e.toJson())
                .toList());
    data['valid_US_Visa'] = validUSVisa?.toString();
    data['valid_US_Visa_valid_till'] = validUSVisaValidTill;
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, value!));
  }
}

class IssuingAuthority {
  String? issuingAuthority;
  String? validTill;
  String? customName;

  IssuingAuthority({this.customName, this.issuingAuthority, this.validTill});

  factory IssuingAuthority.fromJson(Map<String, dynamic> json) {
    return IssuingAuthority(
        issuingAuthority: json['issuing_authority'],
        customName: json['custom_name'],
        validTill: json['valid_till']);
  }

  Map<String, dynamic> toJson() => {
        "issuing_authority": issuingAuthority,
        "custom_name": customName,
        "valid_till": validTill
      };
}

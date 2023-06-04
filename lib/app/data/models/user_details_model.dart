class UserDetails {
  int? userId;
  String? iNDOSNumber;
  String? cDCNumber;
  String? cDCNumberValidTill;
  String? passportNumber;
  String? passportNumberValidTill;
  String? sTCWIssuingAuthority;
  String? sTCWIssuingAuthorityValidTill;
  String? validCOCIssuingAuthority;
  String? validCOCIssuingAuthorityValidTill;
  String? validCOPIssuingAuthority;
  String? validCOPIssuingAuthorityValidTill;
  String? validWatchKeepingIssuingAuthority;
  String? validWatchKeepingIssuingAuthorityValidTill;
  String? validUSVisa;
  String? validUSVisaValidTill;

  UserDetails(
      {this.userId,
      this.iNDOSNumber,
      this.cDCNumber,
      this.cDCNumberValidTill,
      this.passportNumber,
      this.passportNumberValidTill,
      this.sTCWIssuingAuthority,
      this.sTCWIssuingAuthorityValidTill,
      this.validCOCIssuingAuthority,
      this.validCOCIssuingAuthorityValidTill,
      this.validCOPIssuingAuthority,
      this.validCOPIssuingAuthorityValidTill,
      this.validWatchKeepingIssuingAuthority,
      this.validWatchKeepingIssuingAuthorityValidTill,
      this.validUSVisa,
      this.validUSVisaValidTill});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    iNDOSNumber = json['INDOS_number'];
    cDCNumber = json['CDC_number'];
    cDCNumberValidTill = json['CDC_number_valid_till'];
    passportNumber = json['Passport_number'];
    passportNumberValidTill = json['Passport_number_valid_till'];
    sTCWIssuingAuthority = json['STCW_Issuing_Authority'];
    sTCWIssuingAuthorityValidTill = json['STCW_Issuing_Authority_valid_till'];
    validCOCIssuingAuthority = json['valid_COC_Issuing_Authority'];
    validCOCIssuingAuthorityValidTill =
        json['valid_COC_Issuing_Authority_valid_till'];
    validCOPIssuingAuthority = json['valid_COP_Issuing_Authority'];
    validCOPIssuingAuthorityValidTill =
        json['valid_COP_Issuing_Authority_valid_till'];
    validWatchKeepingIssuingAuthority =
        json['valid_Watch_keeping_Issuing_Authority'];
    validWatchKeepingIssuingAuthorityValidTill =
        json['valid_Watch_keeping_Issuing_Authority_valid_till'];
    validUSVisa = json['valid_US_Visa'];
    validUSVisaValidTill = json['valid_US_Visa_valid_till'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['INDOS_number'] = iNDOSNumber;
    data['CDC_number'] = cDCNumber;
    data['CDC_number_valid_till'] = cDCNumberValidTill;
    data['Passport_number'] = passportNumber;
    data['Passport_number_valid_till'] = passportNumberValidTill;
    data['STCW_Issuing_Authority'] = sTCWIssuingAuthority;
    data['STCW_Issuing_Authority_valid_till'] = sTCWIssuingAuthorityValidTill;
    data['valid_COC_Issuing_Authority'] = validCOCIssuingAuthority;
    data['valid_COC_Issuing_Authority_valid_till'] =
        validCOCIssuingAuthorityValidTill;
    data['valid_COP_Issuing_Authority'] = validCOPIssuingAuthority;
    data['valid_COP_Issuing_Authority_valid_till'] =
        validCOPIssuingAuthorityValidTill;
    data['valid_Watch_keeping_Issuing_Authority'] =
        validWatchKeepingIssuingAuthority;
    data['valid_Watch_keeping_Issuing_Authority_valid_till'] =
        validWatchKeepingIssuingAuthorityValidTill;
    data['valid_US_Visa'] = validUSVisa;
    data['valid_US_Visa_valid_till'] = validUSVisaValidTill;
    return data;
  }
}

class Flag {
  int? id;
  String? countryName;
  String? flagCode;
  bool? isActive;

  Flag({this.id, this.countryName, this.flagCode, this.isActive});

  Flag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    flagCode = json['flag_code'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['country_name'] = countryName;
    data['flag_code'] = flagCode;
    data['is_active'] = isActive;
    return data;
  }
}

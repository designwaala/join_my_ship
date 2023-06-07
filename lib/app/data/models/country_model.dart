class Country {
  int? id;
  String? countryCode;
  String? countryName;

  Country({this.countryCode, this.countryName});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['country_code'] = countryCode;
    data['country_name'] = countryName;
    return data;
  }
}

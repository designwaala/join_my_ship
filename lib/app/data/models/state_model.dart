class StateModel {
  int? country;
  String? stateCode;
  String? stateName;

  StateModel({this.country, this.stateCode, this.stateName});

  StateModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    stateCode = json['state_code'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['country'] = country;
    data['state_code'] = stateCode;
    data['state_name'] = stateName;
    return data;
  }
}

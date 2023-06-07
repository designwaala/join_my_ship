class StateModel {
  int? id;
  int? country;
  String? stateCode;
  String? stateName;

  StateModel({this.id, this.country, this.stateCode, this.stateName});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    stateCode = json['state_code'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['country'] = country;
    data['state_code'] = stateCode;
    data['state_name'] = stateName;
    return data;
  }
}

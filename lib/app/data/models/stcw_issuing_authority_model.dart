class StcwIssuingAuthority {
  int? id;
  String? name;

  StcwIssuingAuthority({this.id, this.name});

  StcwIssuingAuthority.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

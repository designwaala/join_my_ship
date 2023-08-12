class PassportIssuingAuthority {
  int? id;
  String? name;

  PassportIssuingAuthority({this.id, this.name});

  PassportIssuingAuthority.fromJson(Map<String, dynamic> json) {
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

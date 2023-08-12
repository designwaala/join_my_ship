class CdcIssuingAuthority {
  int? id;
  String? name;

  CdcIssuingAuthority({this.id, this.name});

  CdcIssuingAuthority.fromJson(Map<String, dynamic> json) {
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

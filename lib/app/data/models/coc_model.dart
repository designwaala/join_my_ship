class Coc {
  int? id;
  String? name;

  Coc({this.id, this.name});

  Coc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, String> toJson() {
    final data = <String, String?>{};
    data['id'] = id?.toString();
    data['name'] = name?.toString();
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, value!));
  }
}

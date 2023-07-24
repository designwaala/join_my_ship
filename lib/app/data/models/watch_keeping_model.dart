class WatchKeeping {
  int? id;
  String? name;

  WatchKeeping({this.id, this.name});

  WatchKeeping.fromJson(Map<String, dynamic> json) {
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

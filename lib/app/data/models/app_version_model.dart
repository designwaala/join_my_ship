class AppVersion {
  int? id;
  String? versionName;

  AppVersion({this.id, this.versionName});

  AppVersion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    versionName = json['version_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['version_name'] = versionName;
    return data;
  }
}

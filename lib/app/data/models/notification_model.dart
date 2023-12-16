class Notification {
  int? id;
  String? userNotify;
  String? title;
  String? body;
  String? data;
  bool? isActive;

  Notification(
      {this.id,
      this.userNotify,
      this.title,
      this.body,
      this.data,
      this.isActive});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userNotify = json['user_notify'];
    title = json['title'];
    body = json['body'];
    data = json['data'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_notify'] = userNotify;
    data['title'] = title;
    data['body'] = body;
    data['data'] = data;
    data['is_active'] = isActive;
    return data;
  }
}

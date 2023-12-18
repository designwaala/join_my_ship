class Notification {
  int? id;
  String? userNotify;
  String? title;
  String? body;
  String? data;
  bool? isActive;
  String? createdAt;

  String elapsedTime() {
    Duration duration =
        DateTime.now().difference(DateTime.parse(createdAt ?? ""));
    if (duration.inHours != 0) {
      if (duration.inHours >= 24) {
        return "${(duration.inHours / 24).ceil()}d ago";
      } else {
        return "${duration.inHours}h ago";
      }
    } else if (duration.inMinutes != 0) {
      return "${duration.inMinutes}m ago";
    } else {
      return "${duration.inSeconds}s ago";
    }
  }

  Notification(
      {this.id,
      this.userNotify,
      this.title,
      this.body,
      this.data,
      this.isActive,
      this.createdAt});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userNotify = json['user_notify'];
    title = json['title'];
    body = json['body'];
    data = json['data'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
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

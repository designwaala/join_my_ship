class Follow {
  int? id;
  int? userId;
  int? userFollowedBy;

  Follow({this.id, this.userId, this.userFollowedBy});

  Follow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userFollowedBy = json['user_followed_by'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_followed_by'] = userFollowedBy;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

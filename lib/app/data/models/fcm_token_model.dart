class FcmToken {
  int? id;
  int? userId;
  String? firebaseToken;

  FcmToken({this.id, this.userId, this.firebaseToken});

  FcmToken.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    firebaseToken = json['firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['firebase_token'] = firebaseToken;
    return data;
  }
}

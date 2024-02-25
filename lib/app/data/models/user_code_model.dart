class UserCode {
  String? userCode;

  UserCode({this.userCode});

  UserCode.fromJson(Map<String, dynamic> json) {
    userCode = json['user_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_code'] = userCode;
    return data;
  }
}

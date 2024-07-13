class TogglePassword {
  bool? isPasswordChange;

  TogglePassword({this.isPasswordChange});

  TogglePassword.fromJson(Map<String, dynamic> json) {
    isPasswordChange = json['is_password_change'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_password_change'] = isPasswordChange;
    return data;
  }
}

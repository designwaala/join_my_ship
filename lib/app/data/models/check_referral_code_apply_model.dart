class CheckReferralCodeApply {
  String? msg;

  CheckReferralCodeApply({this.msg});

  CheckReferralCodeApply.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    return data;
  }
}

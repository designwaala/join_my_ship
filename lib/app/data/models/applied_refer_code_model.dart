class AppliedReferCode {
  int? id;
  int? userRefer;
  String? referCode;

  AppliedReferCode({this.id, this.userRefer, this.referCode});

  AppliedReferCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userRefer = json['user_refer'];
    referCode = json['refer_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_refer'] = userRefer;
    data['refer_code'] = referCode;
    return data;
  }
}

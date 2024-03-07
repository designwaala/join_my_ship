class JobShare {
  int? id;
  int? userCode;
  int? sharedJob;
  bool? isActive;
  String? createdAt;

  JobShare(
      {this.id, this.userCode, this.sharedJob, this.isActive, this.createdAt});

  JobShare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userCode = json['user_code'];
    sharedJob = json['shared_job'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_code'] = userCode;
    data['shared_job'] = sharedJob;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    return data;
  }
}

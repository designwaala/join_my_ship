class JobPostPlanTopUp {
  int? id;
  int? postsLeft;
  int? userTopup;
  bool? isActive;

  JobPostPlanTopUp({this.id, this.postsLeft, this.userTopup, this.isActive});

  JobPostPlanTopUp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postsLeft = json['posts_left'];
    userTopup = json['user_topup'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['posts_left'] = postsLeft;
    data['user_topup'] = userTopup;
    data['is_active'] = isActive;
    return data;
  }
}

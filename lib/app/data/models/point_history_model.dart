class PointHistory {
  int? id;
  int? walletOfUser;
  String? subscriptionName;
  int? pointUsed;
  bool? processSuccessful;
  String? createdAt;
  int? operationType;

  PointHistory(
      {this.id,
      this.walletOfUser,
      this.subscriptionName,
      this.pointUsed,
      this.processSuccessful,
      this.createdAt,
      this.operationType});

  PointHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walletOfUser = json['wallet_of_user'];
    subscriptionName = json['subscription_name'];
    pointUsed = json['point_used'];
    processSuccessful = json['process_successful'];
    createdAt = json['created_at'];
    operationType = json['operation_type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['wallet_of_user'] = walletOfUser;
    data['subscription_name'] = subscriptionName;
    data['point_used'] = pointUsed;
    data['process_successful'] = processSuccessful;
    return data;
  }
}

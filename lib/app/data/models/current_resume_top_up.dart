class CurrentResumeTopUpPack {
  int? id;
  int? userTopUp;
  int? purchaseTopUp;
  bool? isActive;

  CurrentResumeTopUpPack(
      {this.id, this.userTopUp, this.purchaseTopUp, this.isActive});

  factory CurrentResumeTopUpPack.fromJson(Map<String, dynamic> json) =>
      CurrentResumeTopUpPack(
          id: json['id'],
          userTopUp: json['user_topup'],
          purchaseTopUp: json['purchase_top_up'],
          isActive: json['is_active']);
}

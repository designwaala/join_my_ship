class CurrentJobPostPack {
  final int? id;
  final int? userPack;
  final int? purchasePack;
  final bool? isActive;
  final String? createdAt;

  const CurrentJobPostPack(
      {this.id,
      this.userPack,
      this.purchasePack,
      this.isActive,
      this.createdAt});

  factory CurrentJobPostPack.fromJson(Map<String, dynamic> json) =>
      CurrentJobPostPack(
        id: json['id'],
        userPack: json['user_pack'],
        purchasePack: json['purchase_pack'],
        isActive: json['is_active'],
        createdAt: json['created_at']
      );
}

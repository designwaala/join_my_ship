class CurrentResumePack {
  int? id;
  int? userPack;
  int? purchasePack;
  bool? isActive;

  CurrentResumePack({this.id, this.userPack, this.purchasePack, this.isActive});

  factory CurrentResumePack.fromJson(Map<String, dynamic> json) =>
      CurrentResumePack(
          id: json['id'],
          userPack: json['user_pack'],
          purchasePack: json['purchase_pack'],
          isActive: json['is_active']);
}

class ResumeTopUp {
  int? id;
  String? name;
  String? price;
  int? durationDays;
  int? topupLimit;

  ResumeTopUp(
      {this.id, this.name, this.price, this.durationDays, this.topupLimit});

  ResumeTopUp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    durationDays = json['duration_days'];
    topupLimit = json['topup_limit'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['duration_days'] = durationDays;
    data['topup_limit'] = topupLimit;
    return data;
  }
}

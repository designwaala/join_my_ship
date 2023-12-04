class ResumePack {
  int? id;
  String? name;
  String? price;
  int? durationDays;
  int? dailyLimit;

  ResumePack(
      {this.id, this.name, this.price, this.durationDays, this.dailyLimit});

  ResumePack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    durationDays = json['duration_days'];
    dailyLimit = json['daily_limit'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['duration_days'] = durationDays;
    data['daily_limit'] = dailyLimit;
    return data;
  }
}

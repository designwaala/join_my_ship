class JobPostPlan {
  int? id;
  String? name;
  String? price;
  int? durationDays;
  int? monthlyLimit;

  JobPostPlan(
      {this.id, this.name, this.price, this.durationDays, this.monthlyLimit});

  JobPostPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    durationDays = json['duration_days'];
    monthlyLimit = json['monthly_limit'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['duration_days'] = durationDays;
    data['monthly_limit'] = monthlyLimit;
    return data;
  }
}

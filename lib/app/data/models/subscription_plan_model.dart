class SubscriptionPlan {
  int? id;
  Plan? planName;
  int? isTypeKey;
  int? daysActive;
  int? points;

  SubscriptionPlan(
      {this.id, this.planName, this.isTypeKey, this.daysActive, this.points});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName =
        json['plan_name'] == null || json['plan_name'] is! Map<String, dynamic>
            ? null
            : Plan.fromJson(json['plan_name']);
    isTypeKey = json['is_type_key'];
    daysActive = json['days_active'];
    points = json['points'];
  }

  Map<String, String> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['plan_name'] = planName?.planName;
    data['is_type_key'] = isTypeKey;
    data['days_active'] = daysActive;
    data['points'] = points;
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, "$value"));
  }
}

class Plan {
  final int? id;
  final String? planName;

  const Plan({this.id, this.planName});

  factory Plan.fromJson(Map<String, dynamic> json) =>
      Plan(id: json['id'], planName: json['plan_name']);

  Map<String, String> toJson() => {"id": id?.toString(), "plan_name": planName}
      .map((key, value) => MapEntry(key, "$value"));
}

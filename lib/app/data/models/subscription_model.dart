enum PlanType {
  employerHighlight,
  employerBoost,
  crewHighlight,
  crewBoost,
  applyJob;

  String get name {
    switch (this) {
      case PlanType.employerHighlight:
        return "Employer Highlight";
      case PlanType.employerBoost:
        return "Employer Boost";
      case PlanType.crewHighlight:
        return "Crew Highllight";
      case PlanType.crewBoost:
        return "Crew Boost";
      case PlanType.applyJob:
        return "Apply Job";
    }
  }
}

class Subscription {
  int? id;
  PlanName? planName;
  int? daysActive;
  int? points;
  IsTypeKey? isTypeKey;

  Subscription(
      {this.id, this.planName, this.daysActive, this.points, this.isTypeKey});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'] != null
        ? PlanName?.fromJson(json['plan_name'])
        : null;
    daysActive = json['days_active'];
    points = json['points'];
    isTypeKey = json['is_type_key'] != null
        ? IsTypeKey?.fromJson(json['is_type_key'])
        : null;
  }
}

class PlanName {
  int? id;
  String? planName;

  PlanName({this.id, this.planName});

  PlanName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['plan_name'] = planName;
    return data;
  }
}

class IsTypeKey {
  int? id;
  PlanType? type;

  IsTypeKey({this.id, this.type});

  IsTypeKey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  type = () {
      switch (json['id']) {
        case 14:
          return PlanType.employerBoost;
        case 13:
          return PlanType.employerHighlight;
        case 1:
          return PlanType.crewHighlight;
        case 3:
          return PlanType.crewBoost;
        case 5:
          return PlanType.applyJob;
      }
    }();
  }
}

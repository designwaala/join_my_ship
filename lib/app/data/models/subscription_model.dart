enum PlanType {
  highlightProfile,
  jobPost,
  boosting,
  highlightPost,
  applyJob;

  String get name {
    switch (this) {
      case PlanType.highlightProfile:
        return "Hightlight Profile";
      case PlanType.jobPost:
        return "Job Post";
      case PlanType.boosting:
        return "Boosting";
      case PlanType.highlightPost:
        return "Highlight Post";
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
      switch (json['type_name']) {
        case "Highlight Profile":
          return PlanType.highlightProfile;
        case "Job Post":
          return PlanType.jobPost;
        case "Boostig":
          return PlanType.boosting;
        case "Highlight Post":
          return PlanType.highlightPost;
        case "Apply Job":
          return PlanType.applyJob;
      }
    }();
  }
}

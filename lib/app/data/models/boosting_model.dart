import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';

class BoostingResponse {
  String? userBoost;
  String? daysActive;
  String? postBoost;

  BoostingResponse({this.userBoost, this.daysActive, this.postBoost});

  factory BoostingResponse.fromJson(Map<String, dynamic> json) =>
      BoostingResponse(
        userBoost: json['user_boost'],
        daysActive: json['days_active'],
        postBoost: json['post_boost']
      );
}

class Boosting {
  List<Crew>? crewProfiles;
  List<Employer>? jobs;

  Boosting({this.crewProfiles, this.jobs});

  Boosting.fromJson(Map<String, dynamic> json) {
    if (json['crew'] != null) {
      crewProfiles = <Crew>[];
      json['crew'].forEach((v) {
        crewProfiles?.add(Crew.fromJson(v));
      });
    }
    if (json['employer'] != null) {
      jobs = <Employer>[];
      json['employer'].forEach((v) {
        jobs?.add(Employer.fromJson(v));
      });
    }
  }
}

class Crew {
  CrewUser? userBoost;
  int? daysActive;
  bool? isActive;

  Crew({this.userBoost, this.daysActive, this.isActive});

  Crew.fromJson(Map<String, dynamic> json) {
    userBoost = json['user_boost'] != null
        ? CrewUser?.fromJson(json['user_boost'])
        : null;
    daysActive = json['days_active'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (userBoost != null) {
      data['user_boost'] = userBoost?.toJson();
    }
    data['days_active'] = daysActive;
    data['is_active'] = isActive;
    return data;
  }
}

class Employer {
  CrewUser? userBoost;
  Job? postBoost;
  int? daysActive;
  bool? isActive;

  Employer({this.userBoost, this.postBoost, this.daysActive, this.isActive});

  Employer.fromJson(Map<String, dynamic> json) {
    userBoost = json['user_boost'] != null
        ? CrewUser?.fromJson(json['user_boost'])
        : null;
    postBoost =
        json['post_boost'] != null ? Job?.fromJson(json['post_boost']) : null;
    daysActive = json['days_active'];
    isActive = json['is_active'];
  }
}

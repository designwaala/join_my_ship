import 'package:collection/collection.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';

class BoostingResponse {
  String? userBoost;
  int? daysActive;
  String? postBoost;

  BoostingResponse({this.userBoost, this.daysActive, this.postBoost});

  factory BoostingResponse.fromJson(Map<String, dynamic> json) =>
      BoostingResponse(
          userBoost: json['user_boost'],
          daysActive: json['days_active'],
          postBoost: json['post_boost']);
}

class CrewBoostingList {
  int? count;
  String? next;
  String? previous;
  List<Crew>? results;

  CrewBoostingList({this.count, this.next, this.previous, this.results});

  factory CrewBoostingList.fromJson(Map<String, dynamic> json) =>
      CrewBoostingList(
          count: json['count'],
          next: json['next'],
          previous: json['previous'],
          results:
              List<Crew>.from(json['results'].map((e) => Crew.fromJson(e))));
}

class JobBoostingList {
  int? count;
  String? next;
  String? previous;
  List<Employer>? results;
  List<EmployerWithJobs>? jobsGrouped;

  JobBoostingList(
      {this.count, this.next, this.previous, this.results, this.jobsGrouped});

  JobBoostingList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    results =
        List<Employer>.from(json['results'].map((e) => Employer.fromJson(e)));
    jobsGrouped = [];
    if (results != null) {
      results?.forEach((job) {
        if (job.postBoost != null) {
          if (jobsGrouped?.any((e) => e.employer?.id == job.userBoost?.id) ==
              true) {
            jobsGrouped
                ?.firstWhereOrNull((e) => e.employer?.id == job.userBoost?.id)
              ?..jobs ??= []
              ..jobs?.add(job.postBoost!);
          } else {
            jobsGrouped?.add(EmployerWithJobs(
                employer: job.userBoost, jobs: [job.postBoost!]));
          }
        }
      });
    }
  }
}

class Boosting {
  List<Crew>? crewProfiles;
  List<Employer>? jobs;
  List<EmployerWithJobs>? jobsGrouped;

  Boosting({this.crewProfiles, this.jobs, this.jobsGrouped = const []});

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
    jobsGrouped = [];
    if (jobs != null) {
      jobs?.forEach((job) {
        if (job.postBoost != null) {
          if (jobsGrouped?.any((e) => e.employer?.id == job.userBoost?.id) ==
              true) {
            jobsGrouped
                ?.firstWhereOrNull((e) => e.employer?.id == job.userBoost?.id)
              ?..jobs ??= []
              ..jobs?.add(job.postBoost!);
          } else {
            jobsGrouped?.add(EmployerWithJobs(
                employer: job.userBoost, jobs: [job.postBoost!]));
          }
        }
      });
    }
  }
}

class EmployerWithJobs {
  CrewUser? employer;
  List<Job>? jobs;

  EmployerWithJobs({this.employer, this.jobs});
}

class Crew {
  UserDetails? userBoost;
  int? daysActive;
  bool? isActive;

  Crew({this.userBoost, this.daysActive, this.isActive});

  Crew.fromJson(Map<String, dynamic> json) {
    userBoost = json['user_boost'] != null
        ? UserDetails?.fromJson(json['user_boost'])
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

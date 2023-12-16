import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:collection/collection.dart';

/* enum ApplicationStatus {
  APPLIED,
  SHORT_LISTED,
  RESUME_DOWNLOADED;

  int get id {
    switch (this) {
      case ApplicationStatus.APPLIED:
        return 1;
      case ApplicationStatus.SHORT_LISTED:
        return 2;
      case ApplicationStatus.RESUME_DOWNLOADED:
        return 3;
    }
  }
} */

class ApplicationList {
  final int? count;
  final int? next;
  final int? previous;
  final List<Application>? results;

  const ApplicationList({this.count, this.next, this.previous, this.results});

  factory ApplicationList.fromJson(Map<String, dynamic> json) {
    return ApplicationList(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        results: json['results'] == null
            ? null
            : List<Application>.from(
                json['results']?.map((e) => Application.fromJson(e))));
  }
}

class Application {
  int? id;
  int? userId;
  CrewUser? userData;
  UserDetails? userDetails;
  // ApplicationStatus? applicationStatus;
  int? jobId;
  int? rankId;
  Job? jobData;
  bool? appliedStatus;
  bool? shortlistedStatus;
  bool? resumeStatus;
  bool? viewedStatus;

  Application(
      {this.id,
      this.userId,
      this.jobId,
      this.userData,
      // this.applicationStatus,
      this.userDetails,
      this.rankId,
      this.jobData,
      this.appliedStatus,
      this.shortlistedStatus,
      this.resumeStatus,
      this.viewedStatus});

  Application.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'] is int? ? json['user_id'] : null;
    userData = json['user_id'] is Map<String, dynamic>
        ? CrewUser.fromJson(json['user_id'])
        : null;
    userDetails = json['crew_details_user'] == null
        ? null
        : json['crew_details_user'] is List
            ? (json['crew_details_user'] as List).firstOrNull == null
                ? null
                : UserDetails.fromJson(json['crew_details_user'].first)
            : UserDetails.fromJson(json['crew_details_user']);
    // applicationStatus = () {
    //   switch (json['selected_jobs']) {
    //     case 1:
    //       return ApplicationStatus.APPLIED;
    //     case 2:
    //       return ApplicationStatus.SHORT_LISTED;
    //     case 3:
    //       return ApplicationStatus.RESUME_DOWNLOADED;
    //   }
    // }();

    rankId = json['rank_id'];
    jobId = json['job_id'] is int? ? json['job_id'] : null;
    jobData = json['job_id'] is Map<String, dynamic>
        ? Job.fromJson(json['job_id'])
        : null;
    appliedStatus = json['aplied_status'];
    shortlistedStatus = json['shortlisted_status'];
    resumeStatus = json['resume_status'];
    viewedStatus = json['viewed_status'];
  }

  Map<String, String> toJson() {
    final data = <String, String?>{};
    data['id'] = id?.toString();
    data['user_id'] = userId?.toString();
    data['job_id'] = jobId?.toString();
    data['rank_id'] = rankId?.toString();
    data['aplied_status'] = appliedStatus?.toString();
    data['shortlisted_status'] = shortlistedStatus?.toString();
    data['resume_status'] = resumeStatus?.toString();
    data['viewed_status'] = viewedStatus?.toString();
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, value!));
  }
}

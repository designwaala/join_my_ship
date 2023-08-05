import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';

enum ApplicationStatus {
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
}

class Application {
  int? id;
  int? userId;
  CrewUser? userData;
  UserDetails? userDetails;
  ApplicationStatus? applicationStatus;
  int? jobId;

  Application(
      {this.id,
      this.userId,
      this.jobId,
      this.userData,
      this.applicationStatus,
      this.userDetails});

  Application.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'] is int? ? json['user_id'] : null;
    userData = json['user_id'] is Map<String, dynamic>
        ? CrewUser.fromJson(json['user_id'])
        : null;
    userDetails = json['crew_details_user'] == null
        ? null
        : UserDetails.fromJson(json['crew_details_user']);
    applicationStatus = () {
      switch (json['selected_jobs']) {
        case 1:
          return ApplicationStatus.APPLIED;
        case 2:
          return ApplicationStatus.SHORT_LISTED;
        case 3:
          return ApplicationStatus.RESUME_DOWNLOADED;
      }
    }();
    jobId = json['job_id'];
  }

  Map<String, String> toJson() {
    final data = <String, String?>{};
    data['id'] = id?.toString();
    data['user_id'] = userId?.toString();
    data['job_id'] = jobId?.toString();
    data['selected_jobs'] = applicationStatus?.id.toString();
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, value!));
  }
}

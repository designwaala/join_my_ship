import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_rank_with_wages_model.dart';

class Job {
  int? id;
  List<JobCoc>? jobCoc;
  List<JobCop>? jobCop;
  List<JobWatchKeeping>? jobWatchKeeping;
  CrewUser? employerDetails;
  int? employerId;
  List<JobRankWithWages>? jobRankWithWages;
  String? tentativeJoining;
  String? gRT;
  bool? mailInfo;
  bool? numberInfo;
  String? expiryInDay;
  bool? isActive;
  String? createdBy;
  String? modifiedBy;
  String? createdAt;
  String? modifiedAt;
  int? vesselId;
  dynamic postedBy;
  int? jobLikeCount;
  bool? isJobLiked;
  int? vesselIMO;
  int? flag;
  String? joiningPort;

  Job(
      {this.id,
      this.jobCoc,
      this.jobCop,
      this.jobWatchKeeping,
      this.employerDetails,
      this.employerId,
      this.jobRankWithWages,
      this.tentativeJoining,
      this.gRT,
      this.mailInfo,
      this.numberInfo,
      this.expiryInDay,
      this.isActive,
      this.createdBy,
      this.modifiedBy,
      this.createdAt,
      this.modifiedAt,
      this.vesselId,
      this.postedBy,
      this.jobLikeCount,
      this.isJobLiked,
      this.vesselIMO,
      this.flag,
      this.joiningPort});

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['job_coc'] != null) {
      jobCoc = <JobCoc>[];
      json['job_coc'].forEach((v) {
        jobCoc?.add(JobCoc.fromJson(v));
      });
    }
    if (json['job_cop'] != null) {
      jobCop = <JobCop>[];
      json['job_cop'].forEach((v) {
        jobCop?.add(JobCop.fromJson(v));
      });
    }
    jobWatchKeeping = json['job_Watch_Keeping'] == null
        ? null
        : List<JobWatchKeeping>.from(
            json['job_Watch_Keeping'].map((e) => JobWatchKeeping.fromJson(e)));
    jobRankWithWages = json['Job_Rank_wages'] == null
        ? null
        : List<JobRankWithWages>.from(
            json['Job_Rank_wages'].map((e) => JobRankWithWages.fromJson(e)));
    employerDetails =
        json['posted_by'] == null || json['posted_by'] is! Map<String, dynamic>
            ? null
            : CrewUser.fromJson(json['posted_by']);
    employerId = json['posted_by'] is int? ? json['posted_by'] : null;
    tentativeJoining = json['tentative_joining'];
    gRT = json['GRT'];
    mailInfo = json['mail_info'];
    numberInfo = json['number_info'];
    expiryInDay = json['expiry_in_day'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    vesselId = json['vessel_id'];
    postedBy = json['posted_by'];
    jobLikeCount = json['joblike_count'];
    isJobLiked = json['userlikedjob_status'];
    vesselIMO = json['vessel_imo'];
    flag = json['flag_key'];
    joiningPort = json['joining_port'];
  }

  Map<String, String> jsonToUpdateJob() => {
        if (tentativeJoining != null) "tentative_joining": "$tentativeJoining",
        if (gRT != null) "GRT": "$gRT",
        if (mailInfo != null) "mail_info": "$mailInfo",
        if (numberInfo != null) "number_info": "$numberInfo",
        if (vesselId != null) "vessel_id": "$vesselId",
        if (mailInfo != null) "mail_info": "$mailInfo",
        if (numberInfo != null) "number_info": "$numberInfo",
        if (vesselIMO != null) "vessel_imo": "$vesselIMO",
        if (flag != null) "flag_key": "$flag",
        if (joiningPort != null) "joining_port": "$joiningPort",
      };

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (jobCoc != null) {
      data['job_coc'] = jobCoc?.map((v) => v.toJson()).toList();
    }
    if (jobCop != null) {
      data['job_cop'] = jobCop?.map((v) => v.toJson()).toList();
    }
    data['tentative_joining'] = tentativeJoining;
    data['GRT'] = gRT;
    data['mail_info'] = mailInfo;
    data['number_info'] = numberInfo;
    data['expiry_in_day'] = expiryInDay;
    data['is_active'] = isActive;
    data['created_by'] = createdBy;
    data['modified_by'] = modifiedBy;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    data['vessel_id'] = vesselId;
    data['posted_by'] = postedBy;
    data['vessel_imo'] = vesselIMO;
    data['flag_key'] = flag;
    data['joining_port'] = joiningPort;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class JobCoc {
  int? id;
  bool? isActive;
  String? createdBy;
  String? modifiedBy;
  String? createdAt;
  String? modifiedAt;
  int? jobId;
  int? cocId;

  JobCoc(
      {this.id,
      this.isActive,
      this.createdBy,
      this.modifiedBy,
      this.createdAt,
      this.modifiedAt,
      this.jobId,
      this.cocId});

  JobCoc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    jobId = json['job_id'];
    cocId = json['coc_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_active'] = isActive;
    data['created_by'] = createdBy;
    data['modified_by'] = modifiedBy;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    data['job_id'] = jobId;
    data['coc_id'] = cocId;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class JobCop {
  int? id;
  bool? isActive;
  String? createdBy;
  String? modifiedBy;
  String? createdAt;
  String? modifiedAt;
  int? jobId;
  int? copId;

  JobCop(
      {this.id,
      this.isActive,
      this.createdBy,
      this.modifiedBy,
      this.createdAt,
      this.modifiedAt,
      this.jobId,
      this.copId});

  JobCop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    jobId = json['job_id'];
    copId = json['cop_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_active'] = isActive;
    data['created_by'] = createdBy;
    data['modified_by'] = modifiedBy;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    data['job_id'] = jobId;
    data['cop_id'] = copId;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class JobWatchKeeping {
  int? id;
  bool? isActive;
  String? createdBy;
  String? modifiedBy;
  String? createdAt;
  String? modifiedAt;
  int? jobId;
  int? watchKeepingId;

  JobWatchKeeping(
      {this.id,
      this.isActive,
      this.createdBy,
      this.modifiedBy,
      this.createdAt,
      this.modifiedAt,
      this.jobId,
      this.watchKeepingId});

  JobWatchKeeping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    jobId = json['job_id'];
    watchKeepingId = json['Watch_Keeping_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_active'] = isActive;
    data['created_by'] = createdBy;
    data['modified_by'] = modifiedBy;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    data['job_id'] = jobId;
    data['Watch_Keeping_id'] = watchKeepingId;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

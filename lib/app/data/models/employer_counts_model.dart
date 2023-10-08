class EmployerCounts {
  int? jobCount;
  int? followCount;

  EmployerCounts({this.jobCount, this.followCount});

  EmployerCounts.fromJson(Map<String, dynamic> json) {
    jobCount = json['job_count'];
    followCount = json['follow_count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['job_count'] = jobCount;
    data['follow_count'] = followCount;
    return data;
  }
}

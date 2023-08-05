class Application {
  int? id;
  int? userId;
  int? jobId;

  Application({this.id, this.userId, this.jobId});

  Application.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    jobId = json['job_id'];
  }

  Map<String, String> toJson() {
    final data = <String, String?>{};
    data['id'] = id?.toString();
    data['user_id'] = userId?.toString();
    data['job_id'] = jobId?.toString();
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, value!));
  }
}

class JobRankWithWages {
  int? id;
  int? jobId;
  int? rankNumber;
  String? wages;

  JobRankWithWages({this.id, this.jobId, this.rankNumber, this.wages});

  JobRankWithWages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    rankNumber = json['rank_number'];
    wages = json['wages'];
  }

  Map<String, String> toJson() {
    final data = <String, String?>{};
    data['job_id'] = jobId?.toString();
    data['rank_number'] = rankNumber?.toString();
    data['wages'] = wages?.toString();
    data.removeWhere((key, value) => value == null);
    return data.map((key, value) => MapEntry(key, value!));
  }
}

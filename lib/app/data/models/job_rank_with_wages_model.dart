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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['job_id'] = jobId;
    data['rank_number'] = rankNumber;
    data['wages'] = wages;
    return data;
  }
}

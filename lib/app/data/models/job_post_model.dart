class JobPost {
  int? id;
  String? tentativeJoiningDate;
  int? vesselType;
  int? grt;
  List<int>? rankList;
  List<int>? cocList;
  List<int>? copList;
  List<int>? watchKeepingList;
  int? likes;

  JobPost(
      {this.id,
      this.tentativeJoiningDate,
      this.vesselType,
      this.grt,
      this.rankList,
      this.cocList,
      this.copList,
      this.watchKeepingList,
      this.likes});

  JobPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tentativeJoiningDate = json['tentative_joining_date'];
    vesselType = json['vessel_type'];
    grt = json['grt'];
    rankList = json['rank_list'].cast<int>();
    cocList = json['coc_list'].cast<int>();
    copList = json['cop_list'].cast<int>();
    watchKeepingList = json['watch_keeping_list'].cast<int>();
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['tentative_joining_date'] = tentativeJoiningDate;
    data['vessel_type'] = vesselType;
    data['grt'] = grt;
    data['rank_list'] = rankList;
    data['coc_list'] = cocList;
    data['cop_list'] = copList;
    data['watch_keeping_list'] = watchKeepingList;
    data['likes'] = likes;
    return data;
  }
}

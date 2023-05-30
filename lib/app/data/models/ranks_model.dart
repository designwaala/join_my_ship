class Rank {
  String? name;
  int? rankPriority;
  int? forOtheroption;

  Rank({this.name, this.rankPriority, this.forOtheroption});

  Rank.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rankPriority = json['rank_priority'];
    forOtheroption = json['for_otheroption'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['rank_priority'] = rankPriority;
    data['for_otheroption'] = forOtheroption;
    return data;
  }
}

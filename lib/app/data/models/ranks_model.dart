class Rank {
  int? id;
  String? name;
  int? rankPriority;
  int? forOtheroption;
  bool? coc;
  bool? cop;
  bool? watchKeeping;

  Rank({this.id, this.name, this.rankPriority, this.forOtheroption});

  Rank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rankPriority = json['rank_priority'];
    forOtheroption = json['for_otheroption'];
    coc = true ?? json['coc'];
    cop = true ?? json['cop'];
    watchKeeping = true ?? json['watch_keeping'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['rank_priority'] = rankPriority;
    data['for_otheroption'] = forOtheroption;
    data['coc'] = coc;
    data['cop'] = cop;
    data['watch_keeping'] = watchKeeping;
    return data;
  }
}

class Rank {
  int? id;
  String? name;
  int? rankPriority;
  int? forOtheroption;
  bool? coc;
  bool? cop;
  bool? watchKeeping;
  bool? isPromotable;
  int? promotedTo;
  bool? needSeaServiceRecord;

  Rank(
      {this.id,
      this.name,
      this.rankPriority,
      this.forOtheroption,
      this.isPromotable,
      this.promotedTo,
      this.needSeaServiceRecord});

  Rank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rankPriority = json['rank_priority'];
    forOtheroption = json['for_otheroption'];
    coc = json['coc'];
    cop = json['cop'];
    watchKeeping = json['watch_keeping'];
    isPromotable = json['is_promotable'];
    promotedTo = json['promoted_to'];
    needSeaServiceRecord = json['need_sea_service_record'];
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

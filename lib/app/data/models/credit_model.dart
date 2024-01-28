class Credit {
  int? id;
  int? userCredit;
  int? points;

  Credit({this.id, this.userCredit, this.points});

  Credit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userCredit = json['user_Credit'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_Credit'] = userCredit;
    data['points'] = points;
    return data;
  }
}

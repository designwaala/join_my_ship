class Highlight {
  String? userHighlight;
  int? daysActive;

  Highlight({this.userHighlight, this.daysActive});

  Highlight.fromJson(Map<String, dynamic> json) {
    userHighlight = json['user_highlight'];
    daysActive = json['days_active'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_highlight'] = userHighlight;
    data['days_active'] = daysActive;
    return data;
  }
}

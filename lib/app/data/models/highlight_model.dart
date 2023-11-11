class Highlight {
  String? userHighlight;
  int? daysActive;
  bool? success;
  String? message;

  Highlight({this.userHighlight, this.daysActive, this.success, this.message});

  Highlight.fromJson(Map<String, dynamic> json) {
    userHighlight = json['user_highlight'];
    daysActive = json['days_active'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_highlight'] = userHighlight;
    data['days_active'] = daysActive;
    return data;
  }
}

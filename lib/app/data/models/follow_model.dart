import 'package:join_mp_ship/app/data/models/crew_user_model.dart';

class Follow {
  int? id;
  int? userId;
  CrewUser? userDetails;
  int? userFollowedBy;

  Follow({this.id, this.userId, this.userFollowedBy});

  Follow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'] is int ? json['user_id'] : null;
    userDetails =
        json['user_id'] != null && json['user_id'] is Map<String, dynamic>
            ? CrewUser.fromJson(json['user_id'])
            : json['user_followed_by'] != null &&
                    json['user_followed_by'] is Map<String, dynamic>
                ? CrewUser.fromJson(json['user_followed_by'])
                : null;
    userFollowedBy =
        json['user_followed_by'] is int? ? json['user_followed_by'] : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_followed_by'] = userFollowedBy;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

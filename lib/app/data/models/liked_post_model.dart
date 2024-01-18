import 'package:join_my_ship/app/data/models/job_model.dart';

class LikedPost {
  int? id;
  int? userId;
  int? likedPost;
  Job? likedPostDetail;

  LikedPost({this.id, this.userId, this.likedPost, this.likedPostDetail});

  LikedPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    likedPost = json['liked_post'] is int? ? json['liked_post'] : null;
    likedPostDetail = json['liked_post'] is Map<String, dynamic>
        ? Job.fromJson(json['liked_post'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['liked_post'] = likedPost;
    return data;
  }
}

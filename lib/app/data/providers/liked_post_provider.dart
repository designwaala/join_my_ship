import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/liked_post_model.dart';

class LikedPostProvider extends WrapperConnect {
  LikedPostProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return LikedPost.fromJson(map);
      if (map is List)
        return map.map((item) => LikedPost.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<LikedPost>?> getLikedPost() async {
    final response =
        await get('crew/liked_by_list/${UserStates.instance.crewUser?.id}');
    return response.body;
  }

  Future<Response<LikedPost>> likePost(int? jobPostId) async {
    final response = await post(
        'crew/liked_by_create',
        {
          "user_id": UserStates.instance.crewUser?.id,
          "liked_post": jobPostId.toString()
        },
        decoder: (map) => LikedPost.fromJson(map));
    if ((response.statusCode ?? 999) >= 300) {
      Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 2),
          message:
              "Some error occurred. Perhaps you have already liked this Post"));
    }
    return response;
  }

  Future<Response> unlikePost(int? jobPostId) async =>
      await delete('crew/liked_by_destroy/$jobPostId');
}

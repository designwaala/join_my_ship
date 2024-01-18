import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/follow_model.dart';

class FollowProvider extends WrapperConnect {
  FollowProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Follow.fromJson(map);
      if (map is List) return map.map((item) => Follow.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<Follow?> follow(int theirUserId) async {
    final response = await post(
        "crew/followed_by_create",
        Follow(
                userFollowedBy: PreferencesHelper.instance.userId,
                userId: theirUserId)
            .toJson());
    if ((response.statusCode ?? 999) >= 300) {
      Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 2),
          message:
              "Some error occurred. Perhaps you already follow this Employer."));
    }
    return response.body;
  }

  Future<List<Follow>?> getMyFollowings() async {
    //API NOT WORKING PROPERLY
    final response =
        await get("crew/followed_to_list/${PreferencesHelper.instance.userId}");
    return response.body;
  }

  Future<List<Follow>?> getMyFollowers() async {
    final response =
        await get("crew/followed_by_list/${PreferencesHelper.instance.userId}");
    return response.body;
  }

  Future<int?> unfollow(int followId) async {
    final response = await delete("crew/followed_by_destroy/$followId/");
    return response.statusCode;
  }
}

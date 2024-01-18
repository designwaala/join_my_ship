import 'dart:convert';

import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/user_details_model.dart';

class UserDetailsProvider extends WrapperConnect {
  PreferencesHelper prefs = PreferencesHelper.instance;

  UserDetailsProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return UserDetails.fromJson(map);
      if (map is List)
        return map.map((item) => UserDetails.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<UserDetails?> postUserDetails(UserDetails userDetails) async {
    final response =
        await post('crew/crew_details_create', FormData(userDetails.toJson()),
            decoder: (map) {
      print(map);
      return UserDetails.fromJson(map);
    });
    await prefs.setUserDetailId(response.body?.id);
    return response.body;
  }

  Future<UserDetails?> patchUserDetails(UserDetails userDetails) async {
    final response = await multipartPatch(
        'crew/crew_details_update/${userDetails.userId}', userDetails.toJson());
    print(response);
    return UserDetails.fromJson(response);
  }

  Future<UserDetails?> getUserDetails(int userId) async {
    final response =
        await get("crew/crew_details_list/$userId", decoder: (map) {
      if (map.isEmpty) {
        return null;
      }
      if (map is List) {
        return UserDetails.fromJson(map.first);
      }
    }, contentType: "");
    UserStates.instance.userDetails = response.body;
    if (response.body?.id != null) {
      await prefs.setUserDetailId(response.body?.id);
    }
    return response.body;
  }
}

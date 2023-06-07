import 'dart:convert';

import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/user_details_model.dart';

class UserDetailsProvider extends WrapperConnect {
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
    return response.body;
  }

  Future<UserDetails?> getUserDetails(int userId) async {
    final response =
        await get("crew/crew_details_list/$userId", decoder: (map) {
      if (map.isEmpty) {
        return null;
      }
      return UserDetails.fromJson(map.first);
    }, contentType: "");
    return response.body;
  }
}

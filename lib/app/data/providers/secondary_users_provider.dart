import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/secondary_users_model.dart';

class SecondaryUsersProvider extends WrapperConnect {
  SecondaryUsersProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return SecondaryUsers.fromJson(map);
      if (map is List)
        return map.map((item) => SecondaryUsers.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<SecondaryUsers>?> getSecondaryUsers() async {
    String text = await rootBundle.loadString("assets/secondary_users.json");
    return List<SecondaryUsers>.from(
        jsonDecode(text).map((e) => SecondaryUsers.fromJson(e)));
    final response = await get('secondaryusers/');
    return response.body;
  }

  Future<int?> deleteUser(int userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 504;
  }

  Future<int> inviteNewUser(String emailId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 200;
  }

  Future<Response<SecondaryUsers>> postSecondaryUsers(
          SecondaryUsers secondaryusers) async =>
      await post('secondaryusers', secondaryusers);
  Future<Response> deleteSecondaryUsers(int id) async =>
      await delete('secondaryusers/$id');
}

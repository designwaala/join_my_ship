import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_model.dart';

class LoginProvider extends GetConnect {
  LoginProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Login.fromJson(map);
      if (map is List) return map.map((item) => Login.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<Login?> login() async {
    print(await FirebaseAuth.instance.currentUser?.getIdToken());
    final response = await post<Login?>('myadmin_api/log_in/', {}, headers: {
      "Authorization":
          "Bearer ${await FirebaseAuth.instance.currentUser?.getIdToken()}"
    }, decoder: (map) {
      print(map);
      return Login.fromJson(map);
    });
    await Future.wait([
      PreferencesHelper.instance.setAccessToken(response.body?.data?.access),
      PreferencesHelper.instance.setRefreshToken(response.body?.data?.refresh)
    ]);
    print(response.body?.data?.access);
    print(response.body?.data?.refresh);
    return response.body;
  }
}

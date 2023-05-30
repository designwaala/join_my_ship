import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';

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
    final response = await post('myadmin_api/log_in/', {}, headers: {
      "Authorization":
          "Bearer ${await FirebaseAuth.instance.currentUser?.getIdToken()}"
    });
    return response.body;
  }
}

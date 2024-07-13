import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/password_change_model.dart';

class PasswordChangeProvider extends WrapperConnect {
  PasswordChangeProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return PasswordChange.fromJson(map);
      if (map is List)
        return map.map((item) => PasswordChange.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }
  Future<PasswordChange> postPasswordChange(String password) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    print(token);
    final response = await multipartPost(
        'crew/user_change_password/', {"new_password": password},
        headers: {"Authorization": "Bearer $token"});
    return PasswordChange.fromJson(response);
  }
}

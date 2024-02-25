import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/user_code_model.dart';

class UserCodeProvider extends WrapperConnect {
  UserCodeProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return UserCode.fromJson(map);
      if (map is List)
        return map.map((item) => UserCode.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<UserCode?> getUserCode() async {
    final response = await get('crew/get_user/user_code/');
    return response.body;
  }
}

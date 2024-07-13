import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/toggle_password_model.dart';

class TogglePasswordProvider extends WrapperConnect {
  TogglePasswordProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return TogglePassword.fromJson(map);
      if (map is List)
        return map.map((item) => TogglePassword.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<TogglePassword> passwordResetSetRequestInitiate({required String email}) async {
    final response =
        await multipartPost('myadmin_api/toggle-password-change/$email/', {"is_password_change": "1"}, headers: {});
    return TogglePassword.fromJson(response);
  }

  Future<TogglePassword> passwordResetRequestTerminate({required String email}) async {
    final response =
        await multipartPost('myadmin_api/toggle-password-change/$email/', {"is_password_change": "0"});
    return TogglePassword.fromJson(response);
  }
}

import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/fcm_token_model.dart';

class FcmTokenProvider extends WrapperConnect {
  FcmTokenProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return FcmToken.fromJson(map);
      if (map is List)
        return map.map((item) => FcmToken.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<FcmToken?> postFCMToken(String token) async {
    final response = await post('crew/firebase_token_create', {
      "user_id": PreferencesHelper.instance.userId?.toString(),
      "firebase_token": token
    });
    return response.body;
  }
}

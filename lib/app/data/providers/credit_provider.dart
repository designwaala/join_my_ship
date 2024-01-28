import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/credit_model.dart';

class CreditProvider extends WrapperConnect {
  CreditProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Credit.fromJson(map);
      if (map is List) return map.map((item) => Credit.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<Credit?> getCredit() async {
    final response = await get(
        'myadmin_api/get_credits/${PreferencesHelper.instance.userId}/');
    return response.body;
  }
}

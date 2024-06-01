import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/point_history_model.dart';

class PointHistoryProvider extends WrapperConnect {
  PointHistoryProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return PointHistory.fromJson(map);
      if (map is List)
        return map.map((item) => PointHistory.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<PointHistory>?> getPointHistory() async {
    final response = await get(
        "myadmin_api/get_wallet_history/${PreferencesHelper.instance.userId}",
        query: {"wallet_type":  "1"});
    return response.body;
  }
}

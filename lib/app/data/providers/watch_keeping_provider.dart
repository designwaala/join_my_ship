import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/watch_keeping_model.dart';

class WatchKeepingProvider extends WrapperConnect {
  WatchKeepingProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return WatchKeeping.fromJson(map);
      if (map is List)
        return map.map((item) => WatchKeeping.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<WatchKeeping>?> getWatchKeepingList(
      {required int userType}) async {
    final response =
        await get('employer/watch_keeping_list/$userType', headers: {});
    UserStates.instance.watchKeepings = response.body;
    return response.body;
  }
}

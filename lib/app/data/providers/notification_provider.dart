import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/notification_model.dart';

class NotificationProvider extends WrapperConnect {
  NotificationProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Notification.fromJson(map);
      if (map is List)
        return map.map((item) => Notification.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Notification>?> getNotifications() async {
    final response = await get(
        'crew/notification_list/${PreferencesHelper.instance.userId}/');
    return response.body;
  }
}

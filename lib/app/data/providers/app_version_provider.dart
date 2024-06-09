import 'dart:io';

import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/app_version_model.dart';

class AppVersionProvider extends WrapperConnect {
  AppVersionProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return AppVersion.fromJson(map);
      if (map is List)
        return map.map((item) => AppVersion.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  AppVersion? appVersion;

  Future<AppVersion?> getAppVersion() async {
    final response = appVersion ?? (await get(
        'myadmin_api/app-version/${Platform.isAndroid ? "1" : "2"}/', headers: {})).body;
    appVersion = response;
    return response;
  }
}

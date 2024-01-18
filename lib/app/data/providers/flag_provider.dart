import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/flag_model.dart';

class FlagProvider extends WrapperConnect {
  FlagProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Flag.fromJson(map);
      if (map is List) return map.map((item) => Flag.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Flag>?> getFlags() async {
    final response = await get('crew/flag_list/');
    return response.body;
  }
}

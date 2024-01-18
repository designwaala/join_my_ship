import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/cop_model.dart';

class CopProvider extends WrapperConnect {
  CopProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Cop.fromJson(map);
      if (map is List) return map.map((item) => Cop.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Cop>?> getCOPList({required int userType}) async {
    final response = await get('employer/cop_list/$userType', headers: {});
    UserStates.instance.cops = response.body;
    return response.body;
  }
}

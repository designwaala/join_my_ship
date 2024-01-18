import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/coc_model.dart';

class CocProvider extends WrapperConnect {
  CocProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Coc.fromJson(map);
      if (map is List) return map.map((item) => Coc.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Coc>?> getCOCList({required int userType}) async {
    final response = await get('employer/coc_list/$userType', headers: {});
    UserStates.instance.cocs = response.body;
    return response.body;
  }
}

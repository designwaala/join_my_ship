import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

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
    return response.body;
  }
}

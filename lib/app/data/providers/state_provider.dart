import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/state_model.dart';

class StateProvider extends WrapperConnect {
  StateProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return StateModel.fromJson(map);
      if (map is List) return map.map((item) => StateModel.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<StateModel>?> getStates({required int countryId}) async {
    final response = await get('employer/state_list/$countryId');
    return response.body;
  }
}

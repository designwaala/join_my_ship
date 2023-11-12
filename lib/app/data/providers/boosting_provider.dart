import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/boosting_model.dart';

class BoostingProvider extends WrapperConnect {
  BoostingProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Boosting.fromJson(map);
      if (map is List)
        return map.map((item) => Boosting.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<Boosting?> getBoosting() async {
    final response = await get('crew/get_boosted');
    return response.body;
  }

  Future<BoostingResponse?> boostCrewProfile(
      {required int subscriptionId}) async {
    final response = await multipartPost(
        "crew/crew_boosting", {"sub_id": "$subscriptionId"});
    return BoostingResponse.fromJson(response);
  }

  Future<BoostingResponse?> boostJob(
      {required int subscriptionId, required int postBoost}) async {
    final response = await multipartPost("crew/employer_boosting",
        {"sub_id": "$subscriptionId", "post_boost": "$postBoost"});
    return BoostingResponse.fromJson(response);
  }
}

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

  Future<CrewBoostingList?> getCrewBoosting({int? page}) async {
    final response = await get("crew/get_boosted_crew",
        query: {if (page != null) "page": "$page"}, decoder: (data) {
      try {
        return CrewBoostingList.fromJson(data);
      } catch (e) {}
      return null;
    });
    return response.body;
  }

  Future<List<Map<String, List<Employer>>>?> getJobBoosting({int? page}) async {
    final response = await get<List<Map<String, List<Employer>>>>(
        "crew/get_boosted_employer", decoder: (data) {
      return List<Map<String, List<Employer>>>.from(data.map((e) =>
          Map<String, List<Employer>>.fromEntries((e as Map<String, dynamic>)
              .keys
              .map((p0) => MapEntry<String, List<Employer>>(
                  p0,
                  List<Employer>.from(
                      e[p0].map((p1) => Employer.fromJson(p1))))))));
    }, query: {"limit": "10", if (page != null) "page": "$page"});
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

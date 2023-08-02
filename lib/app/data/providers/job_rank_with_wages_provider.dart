import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/job_rank_with_wages_model.dart';

class JobRankWithWagesProvider extends WrapperConnect {
  JobRankWithWagesProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return JobRankWithWages.fromJson(map);
      if (map is List)
        return map.map((item) => JobRankWithWages.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<JobRankWithWages> postJobRankWithWages(
          JobRankWithWages jobrankwithwages) async =>
      (await post('employer/rank_with_wages', jobrankwithwages.toJson())).body;

  Future<JobRankWithWages?> updateJobRankWithWages(
      JobRankWithWages jobrankwithwages) async {
    final response = await multipartPatch(
        'employer/rank_with_wages_update/${jobrankwithwages.id}',
        jobrankwithwages,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"
        });
    return JobRankWithWages.fromJson(response);
  }

  Future<int?> deleteJobRankWithWages(
          JobRankWithWages jobrankwithwages) async =>
      (await delete(
              'employer/rank_with_wages_retrieve_destroy/${jobrankwithwages.id}'))
          .statusCode;
}

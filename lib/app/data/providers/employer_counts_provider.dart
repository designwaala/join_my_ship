import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/employer_counts_model.dart';

class EmployerCountsProvider extends WrapperConnect {
 EmployerCountsProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return EmployerCounts.fromJson(map);
      if (map is List)
        return map.map((item) => EmployerCounts.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<EmployerCounts?> getEmployerCounts() async {
    final response = await get('employer/get_count_jobs_follow');
    return response.body;
  }

}

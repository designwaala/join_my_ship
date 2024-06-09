import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/job_post_plan_model.dart';

class JobPostPlanProvider extends WrapperConnect {
  JobPostPlanProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return JobPostPlan.fromJson(map);
      if (map is List)
        return map.map((item) => JobPostPlan.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<JobPostPlan>?> getJobPostPlan() async {
    final response = await get('employer/job-post-plans/');
    return response.body;
  }
}

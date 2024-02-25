import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/job_post_top_up_packs.dart';
import 'package:join_my_ship/app/modules/subscriptions/controllers/subscriptions_controller.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/job_post_plan_top_up_model.dart';

class JobPostPlanTopUpProvider extends WrapperConnect {
  JobPostPlanTopUpProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return JobPostPlanTopUp.fromJson(map);
      if (map is List)
        return map.map((item) => JobPostPlanTopUp.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<JobPostPlanTopUp?> getJobPostPlanTopUp() async {
    final response = await get(
        "employer/get_job_post_topup_plan/${PreferencesHelper.instance.userId}/");
    return response.body;
  }

  Future<JobPostPlanTopUp?> jobPostPlanTopUp(
      {required JobPostTopUpPack topUpPack}) async {
    final response = await multipartPost('employer/job_post_topup_plan/', {
      "post_purchased": "${topUpPack.postPurchased}",
      "points_used": "${topUpPack.pointsUsed}"
    });
    return JobPostPlanTopUp.fromJson(response);
  }
}

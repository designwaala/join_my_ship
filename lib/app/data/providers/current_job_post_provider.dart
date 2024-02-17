import 'package:join_my_ship/app/data/models/current_job_post_pack.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

class CurrentJobPostProvider extends WrapperConnect {
  CurrentJobPostProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return CurrentJobPostPack.fromJson(map);
    };
    httpClient.baseUrl = baseURL;
  }

  Future<CurrentJobPostPack?> buyJobPost() async {
    final response = await multipartPost(
        "employer/apply_plan_job_post/", {"purchase_plan": "2"});
    return CurrentJobPostPack.fromJson(response);
  }

    Future<CurrentJobPostPack?> startFreeTrial() async {
    final response = await multipartPost(
        "employer/apply_plan_job_post/", {"purchase_plan": "1"});
    return CurrentJobPostPack.fromJson(response);
  }
}

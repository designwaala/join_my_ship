import 'package:join_my_ship/app/data/models/current_job_post_pack.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
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
        "employer/apply_plan_job_post/", {"purchase_pack": "2"});
    return CurrentJobPostPack.fromJson(response);
  }

  Future<CurrentJobPostPack?> startFreeTrial() async {
    final response = await multipartPost(
        "employer/apply_plan_job_post/", {"purchase_pack": "1"});
    return CurrentJobPostPack.fromJson(response);
  }

  Future<List<CurrentJobPostPack>?> getCurrentJobPostPacks() async {
    final response = await get(
      "employer/job_post_subscribed_pack_plan/${PreferencesHelper.instance.userId}/",
      decoder: (data) => List<CurrentJobPostPack>.from(
          data.map((e) => CurrentJobPostPack.fromJson(e))),
    );
    return response.body;
  }
}

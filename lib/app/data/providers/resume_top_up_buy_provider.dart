import 'package:join_my_ship/app/data/models/current_resume_top_up.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

class ResumeTopUpBuyProvider extends WrapperConnect {
  ResumeTopUpBuyProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>)
        return CurrentResumeTopUpPack.fromJson(map);
      if (map is List)
        return map
            .map((item) => CurrentResumeTopUpPack.fromJson(item))
            .toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<CurrentResumeTopUpPack?> buyTopUp(int topUpId) async {
    final response = await multipartPost(
        "crew/purchase_topup/", {"purchase_top_up": "$topUpId"});
    return CurrentResumeTopUpPack.fromJson(response);
  }

  Future<List<CurrentResumeTopUpPack>?> getTopUpPurchases() async {
    final response = await get(
        "crew/subscribed_topup_plan/${PreferencesHelper.instance.userId}");
    return response.body;
  }
}

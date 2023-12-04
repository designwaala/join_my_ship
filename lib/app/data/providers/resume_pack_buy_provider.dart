import 'package:join_mp_ship/app/data/models/current_resume_pack.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

class ResumePackBuyProvider extends WrapperConnect {
  ResumePackBuyProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return CurrentResumePack.fromJson(map);
      if (map is List)
        return map.map((item) => CurrentResumePack.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<CurrentResumePack?> buyResumePack(int planId) async {
    final response = await multipartPost(
        "crew/purchase_pack/", {"purchase_pack": "$planId"});
    return CurrentResumePack.fromJson(response);
  }

  Future<List<CurrentResumePack>?> getCurrentBoughtPacks() async {
    final response = await get(
        "crew/subscribed_pack_plan/${PreferencesHelper.instance.userId}");
    return response.body;
  }
}

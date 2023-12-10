import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/highlight_model.dart';

class HighlightProvider extends WrapperConnect {
  HighlightProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Highlight.fromJson(map);
      if (map is List)
        return map.map((item) => Highlight.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<Highlight> crewHighlight(int subscriptionId) async {
    final response = await multipartPost(
        'crew/subscripstions_pay', {"sub_id": subscriptionId.toString()});
    return Highlight.fromJson(response);
  }

  Future<Highlight> jobHighlight(
      {required int jobId, required int subscriptionId}) async {
    final response = await multipartPost("crew/subscripstions_pay",
        {"sub_id": subscriptionId.toString(), "post_id": jobId.toString()});
    return Highlight.fromJson(response);
  }

  Future<List<Highlight>?> fetchCrewHighlight() async {
    final response = await get(
        "crew/subscribed_highlight_plan/${PreferencesHelper.instance.userId}");
    return response.body;
  }
}

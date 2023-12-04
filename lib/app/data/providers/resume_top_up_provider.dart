import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/resume_top_up_model.dart';

class ResumeTopUpProvider extends WrapperConnect {
  ResumeTopUpProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return ResumeTopUp.fromJson(map);
      if (map is List)
        return map.map((item) => ResumeTopUp.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<ResumeTopUp>?> getResumeTopUp() async {
    final response = await get('crew/topup-plan/');
    return response.body;
  }

}

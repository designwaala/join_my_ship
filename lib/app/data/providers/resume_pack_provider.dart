import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/resume_pack_model.dart';

class ResumePackProvider extends WrapperConnect {
  ResumePackProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return ResumePack.fromJson(map);
      if (map is List)
        return map.map((item) => ResumePack.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<ResumePack>> getResumePacks() async {
    final response = await get('crew/pack-plan/');
    return response.body;
  }
}

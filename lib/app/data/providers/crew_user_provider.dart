import 'package:get/get.dart';

import '../../../main.dart';
import '../models/crew_user_model.dart';

class CrewUserProvider extends GetConnect {
  CrewUserProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return CrewUser.fromJson(map);
      if (map is List)
        return map.map((item) => CrewUser.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<CrewUser?> getCrewUser(int id) async {
    final response = await get('crewuser/$id');
    return response.body;
  }

  Future<CrewUser?> createCrewUser({required CrewUser crewUser}) async {
    final response = await post("crew/user_create", crewUser.toJson());
    return response.body;
  }
}

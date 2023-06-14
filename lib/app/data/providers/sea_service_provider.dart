import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/sea_service_model.dart';

class SeaServiceProvider extends WrapperConnect {
  SeaServiceProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return SeaServiceRecord.fromJson(map);
      if (map is List)
        return map.map((item) => SeaServiceRecord.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<SeaServiceRecord>?> getSeaServices(int userId) async {
    final response = await get('crew/sea_services_list/$userId');
    return response.body;
  }

  Future<SeaServiceRecord?> postSeaService(SeaServiceRecord seaservice) async =>
      (await post('crew/sea_services_create', FormData(seaservice.toJson())))
          .body;

  Future<SeaServiceRecord?> updateSeaService(
      SeaServiceRecord seaService) async {
    final response = await httpPatch(
        "crew/sea_services_update/${seaService.id}", seaService.toJson());
    return SeaServiceRecord.fromJson(response);
  }

  Future<Response> deleteSeaService(int id) async =>
      await delete('crew/sea_services_destroy/$id/');
}

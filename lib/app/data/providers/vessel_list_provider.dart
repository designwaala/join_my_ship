import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';

import '../models/vessel_list_model.dart';

class VesselListProvider extends GetConnect {
  VesselListProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return VesselList.fromJson(map);
      if (map is List)
        return map.map((item) => VesselList.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<VesselList?> getVesselList() async {
    final response = await get('employer/vessels_list', headers: {});
    return response.body;
  }

  Future<Response<VesselList>> postVesselList(VesselList vessellist) async =>
      await post('vessellist', vessellist);
  Future<Response> deleteVesselList(int id) async =>
      await delete('vessellist/$id');
}

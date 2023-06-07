import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';

import '../models/vessel_type_model.dart';

class VesselTypeProvider extends GetConnect {
  VesselTypeProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return VesselType.fromJson(map);
      if (map is List)
        return map.map((item) => VesselType.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<VesselType>?> getVesselTypes() async {
    final response = await get('employer/vesselstype_list');
    return response.body;
  }

  Future<Response<VesselType>> postVesselType(VesselType vesseltype) async =>
      await post('vesseltype', vesseltype.toJson());
  Future<Response> deleteVesselType(int id) async =>
      await delete('vesseltype/$id');
}

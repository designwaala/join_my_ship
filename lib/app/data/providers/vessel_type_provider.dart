import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/vessel_type_model.dart';

class VesselTypeProvider extends WrapperConnect {
  VesselTypeProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return VesselType.fromJson(map);
      if (map is List) {
        return map.map((item) => VesselType.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<VesselType>?> getVesselTypes() async {
    final response = await get('employer/vessels_list');
    return response.body;
  }

  Future<Response<VesselType>> postVesselType(VesselType vesseltype) async =>
      await post('vesseltype', vesseltype.toJson());
  Future<Response> deleteVesselType(int id) async =>
      await delete('vesseltype/$id');
}

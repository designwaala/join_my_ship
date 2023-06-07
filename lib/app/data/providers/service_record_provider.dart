// import 'package:get/get.dart';
// import 'package:join_mp_ship/main.dart';
// import 'package:join_mp_ship/utils/wrapper_connect.dart';

// import '../models/service_record_model.dart';

// class ServiceRecordProvider extends WrapperConnect {
//   ServiceRecordProvider() {
//     httpClient.defaultDecoder = (map) {
//       if (map is Map<String, dynamic>) return ServiceRecord.fromJson(map);
//       if (map is List)
//         return map.map((item) => ServiceRecord.fromJson(item)).toList();
//     };
//     httpClient.baseUrl = baseURL;
//   }

//   Future<ServiceRecord?> postServiceRecord(
//           ServiceRecord servicerecord) async =>
//       (await post('crew/sea_services_create', servicerecord)).body;
//   Future<Response> deleteServiceRecord(int id) async =>
//       await delete('crew/sea_services_destroy/$id/');
// }

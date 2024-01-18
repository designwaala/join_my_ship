// import 'package:get/get.dart';
// import 'package:join_my_ship/main.dart';
// import 'package:join_my_ship/utils/wrapper_connect.dart';

// import '../models/previous_employer_reference_model.dart';

// class PreviousEmployerReferenceProvider extends WrapperConnect {
//   PreviousEmployerReferenceProvider() {
//     httpClient.defaultDecoder = (map) {
//       if (map is Map<String, dynamic>)
//         return PreviousEmployerReference.fromJson(map);
//       if (map is List)
//         return map
//             .map((item) => PreviousEmployerReference.fromJson(item))
//             .toList();
//     };
//     httpClient.baseUrl = baseURL;
//   }

//   Future<PreviousEmployerReference?> getPreviousEmployerReference(
//       int id) async {
//     final response = await get('previousemployerreference/$id');
//     return response.body;
//   }

//   Future<Response<PreviousEmployerReference>> postPreviousEmployerReference(
//           PreviousEmployerReference previousemployerreference) async =>
//       await post('crew/previous_employer_create', previousemployerreference);
//   Future<Response> deletePreviousEmployerReference(int id) async =>
//       await delete('crew/previous_employer_destroy/$id/');
// }

import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/previous_employer_model.dart';

class PreviousEmployerProvider extends WrapperConnect {
  PreviousEmployerProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>)
        return PreviousEmployerReference.fromJson(map);
      if (map is List)
        return map
            .map((item) => PreviousEmployerReference.fromJson(item))
            .toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<PreviousEmployerReference>?> getPreviousEmployer(
      int userId) async {
    final response = await get('crew/previous_employer_list/$userId');
    return response.body;
  }

  Future<PreviousEmployerReference?> postPreviousEmployer(
          PreviousEmployerReference previousemployer) async =>
      (await post('crew/previous_employer_create',
              FormData(previousemployer.toJson())))
          .body;

  Future<PreviousEmployerReference?> patchPreviousEmployer(
      PreviousEmployerReference previousEmployer) async {
    final response = await multipartPatch(
        "crew/previous_employer_update/${previousEmployer.id}",
        previousEmployer.toJson());
    return PreviousEmployerReference.fromJson(response);
  }

  Future<Response> deletePreviousEmployer(int id) async =>
      await delete('crew/previous_employer_destroy/$id/');
}

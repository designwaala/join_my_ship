import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/application_model.dart';

class ApplicationProvider extends WrapperConnect {
  ApplicationProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Application.fromJson(map);
      if (map is List)
        return map.map((item) => Application.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Application>> getAppliedJobList() async {
    final response = await get(
        "employer/apply_job_list/${PreferencesHelper.instance.userId}");
    return response.body;
  }

  Future<Application?> getApplication(int id) async {
    final response = await get('application/$id');
    return response.body;
  }

  Future<Application?> apply(Application application) async {
    final response =
        await multipartPost('employer/apply_job', application.toJson());
    if (response.keys.join().contains("non_field_errors")) {
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        message:
            "Some error occurred. Perhaps you have already applied for this Job.",
      ));
      return null;
    }
    return Application.fromJson(response);
  }

  Future<Response> deleteApplication(int id) async =>
      await delete('application/$id');
}

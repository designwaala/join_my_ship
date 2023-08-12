import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';
import 'package:collection/collection.dart';

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

  Future<ApplicationList?> getAppliedJobList() async {
    final response = await get(
        "employer/apply_job_list/${PreferencesHelper.instance.userId}",
        decoder: (map) => ApplicationList.fromJson(map));
    return response.body;
  }

  Future<ApplicationList?> getAppliedJobListWithoutJobData() async {
    final response = await get(
        "employer/applled_job_list/${PreferencesHelper.instance.userId}",
        decoder: (map) => ApplicationList.fromJson(map));
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

  Future<List<Application>?> getApplicationsForAJob(int jobId,
      {List<int>? ranks,
      List<int>? genders,
      List<ApplicationStatus>? statuses}) async {
    final response = await httpGet(
        uri: Uri(
            scheme: "https",
            host: "designwaala.me",
            path: "employer/applicants_list/$jobId",
            queryParameters: {
          if (ranks != null) "rank": ranks.map((e) => e.toString()).toList(),
          if (genders != null)
            "gender": genders.map((e) => e.toString()).toList(),
          if (statuses != null)
            "status": statuses.map((e) => e.id.toString()).toList(),
        })
        // "employer/applicants_list/$jobId?${query.map((e) => "${e.key}=${e.value}").join("?")}"
        );
    if (response == null) {
      return null;
    }
    return List<Application>.from(response.map((e) => Application.fromJson(e)));
  }

  Future<Application?> shortListApplication(int applicationId) async {
    final response = await multipartPatch(
        "employer/applicants_update/$applicationId",
        Application(applicationStatus: ApplicationStatus.SHORT_LISTED)
            .toJson());
    return Application.fromJson(response);
  }

  Future<Application?> downloadResumeForApplication(int jobId) async {
    final response = await multipartPatch("employer/applicants_update/$jobId",
        Application(applicationStatus: ApplicationStatus.RESUME_DOWNLOADED));
    return Application.fromJson(response);
  }

  Future<Response> deleteApplication(int id) async =>
      await delete('application/$id');
}

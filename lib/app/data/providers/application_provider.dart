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

  Future<List<Application>?> getAppliedJobListWithoutJobData() async {
    final response = await get(
        "employer/applled_job_list/${PreferencesHelper.instance.userId}",
        decoder: (map) =>
            List<Application>.from((map).map((e) => Application.fromJson(e))));
    return response.body;
  }

  Future<Application?> apply(
      {int? userId, int? jobId, int? rankId, int? subId}) async {
    final response = await multipartPost('employer/apply_job', {
      if (userId != null) "user_id": "$userId",
      if (jobId != null) "job_id": "$jobId",
      if (rankId != null) "rank_id": "$rankId",
      if (subId != null) "sub_id": "$subId"
    });
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
      int? appliedStatus,
      int? shortlistedStatus,
      int? resumeStatus,
      int? viewedStatus}) async {
    final response = await httpGet(
        uri: Uri(
            scheme: "https",
            host: "designwaala.me",
            path: "employer/applicants_list/$jobId",
            queryParameters: {
          if (ranks != null) "rank": ranks.map((e) => e.toString()).toList(),
          if (genders != null)
            "gender": genders.map((e) => e.toString()).toList(),
          if (appliedStatus != null) "aplied_status": appliedStatus.toString(),
          if (shortlistedStatus != null)
            "shortlisted_status": shortlistedStatus.toString(),
          if (resumeStatus != null) "resume_status": resumeStatus.toString(),
          if (viewedStatus != null) "viewed_status": viewedStatus.toString()
        })
        // "employer/applicants_list/$jobId?${query.map((e) => "${e.key}=${e.value}").join("?")}"
        );
    if (response == null) {
      return null;
    }
    return List<Application>.from(response.map((e) => Application.fromJson(e)));
  }

  Future<int?> shortListApplication(Application application) async {
    final response = await get(
        "crew/profile/shortlisted/${application.userData?.id}/${application.jobData?.id ?? application.jobId}",
        decoder: (data) => data);
    return response.statusCode;
  }

  Future<Application?> unshortListApplication(int applicationId) async {
    final response = await multipartPatch(
        "employer/applicants_update/$applicationId",
        Application(shortlistedStatus: false).toJson());
    return Application.fromJson(response);
  }

  Future<int?> viewApplication(int crewId, int jobId) async {
    final response = await get("crew/profile/viewed/$crewId/$jobId",
        decoder: (data) => data);
    return response.statusCode;
  }

/*   Future<Application?> downloadResumeForApplication(int jobId) async {
    final response = await multipartPatch("employer/applicants_update/$jobId",
        Application(applicationStatus: ApplicationStatus.RESUME_DOWNLOADED));
    return Application.fromJson(response);
  } */

  Future<String?> downloadResumeForApplication(int? jobId, int crewId) async {
    final response = await multipartPost("crew/resume-downloads/",
        {if (jobId != null) "job_id": "$jobId", "user_id": "$crewId"});
    return response["resume_download_url"];
  }

  //OLD API
  /* Future<String?> downloadResumeForApplication(int jobId, int crewId) async {
    final response = await get("crew/resume/download/$crewId/$jobId",
        decoder: (map) => map['resume_download_url']);
    return response.body;
  } */
}

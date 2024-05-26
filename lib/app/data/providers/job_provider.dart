import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/job_model.dart';

class JobProvider extends WrapperConnect {
  JobProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Job.fromJson(map);
      if (map is List) return map.map((item) => Job.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<Job?> getJob(int jobId) async {
    final response = await get("employer/post_job_retrieve/$jobId",
        decoder: (data) => Job.fromJson(data));
    return response.body;
  }

  Future<List<Job>?> getJobList(
      {int? employerId, List<int>? ranks, List<int>? vesselIds}) async {
    final response = await httpGet(
        uri: Uri(
            scheme: "https",
            host: "joinmyship.com",
            path: "employer/post_job_list",
            queryParameters: {
          "is_verified": "true",
          "is_active": "true",
          if (employerId != null) "emp_id": "$employerId",
          if (ranks?.isNotEmpty == true)
            "rank": ranks?.map((e) => e.toString()),
          if (vesselIds?.isNotEmpty == true)
            "vessel_id": vesselIds?.map((e) => e.toString())
        }));

    return List<Job>.from(response.map((e) => Job.fromJson(e)));
  }

  Future<Job> postJob(Job job) async =>
      (await post('employer/post_job', job.toJson())).body;

  Future<Job> updateJob(Job job) async {
    final response = await httpPatch(
        "employer/post_job_update/${job.id}", job.jsonToUpdateJob(),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"
        });
    return Job.fromJson(response);
  }

  Future<int?> deleteJob(int jobId) async =>
      (await delete("employer/post_job_retrieve_destroy/$jobId")).statusCode;
}

import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

class JobWatchKeepingPostProvider extends WrapperConnect {
  JobWatchKeepingPostProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return JobWatchKeeping.fromJson(map);
      if (map is List)
        return map.map((item) => JobWatchKeeping.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<JobWatchKeeping> postJobWatchKeeping(
      JobWatchKeeping jobWatchKeeping) async {
    final response =
        await post("employer/Watch_Keeping_list_JOb", jobWatchKeeping.toJson());
    return response.body;
  }

  Future<JobWatchKeeping> updateJobWatchKeeping(
      JobWatchKeeping jobWatchKeeping) async {
    final response = await httpPatch(
        "employer/Watch_Keeping_list_JOb_update/${jobWatchKeeping.id}",
        jobWatchKeeping.toJson());
    return JobWatchKeeping.fromJson(response);
  }

  Future<int?> deleteJobWatchKeeping(JobWatchKeeping jobWatchKeeping) async {
    final response = await delete(
        "employer/Watch_Keeping_list_JOb_retrieve_destroy/${jobWatchKeeping.id}");
    return response.statusCode;
  }
}

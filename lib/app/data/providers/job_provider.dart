import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/job_model.dart';

class JobProvider extends WrapperConnect {
  JobProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Job.fromJson(map);
      if (map is List) return map.map((item) => Job.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Job>?> getJobList() async {
    final response = await get('employer/post_job_list');
    return response.body;
  }

  Future<Job> postJob(Job job) async =>
      (await post('employer/post_job', job.toJson())).body;
}

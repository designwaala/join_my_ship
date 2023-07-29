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

  Future<Job?> getJob(int id) async {
    final response = await get('job/$id');
    return response.body;
  }

  Future<Response<Job>> postJob(Job job) async => await post('job', job);
  Future<Response> deleteJob(int id) async => await delete('job/$id');
}

import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/job_share_model.dart';

class JobShareProvider extends WrapperConnect {
  JobShareProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return JobShare.fromJson(map);
      if (map is List)
        return map.map((item) => JobShare.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<JobShare?> applyJobShare(
      {required String userCode, required int jobId}) async {
    final response = await multipartPost(
        'myadmin_api/jobshared/create/', {"code_send": userCode, "shared_job": "$jobId"});
    return JobShare.fromJson(response);
  }
}

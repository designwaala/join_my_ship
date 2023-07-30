import 'dart:convert';

import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

class JobCOCPostProvider extends WrapperConnect {
  JobCOCPostProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return JobCoc.fromJson(map);
      if (map is List) return map.map((item) => JobCoc.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<JobCoc> postJobCOC(JobCoc jobcoc) async {
    final response = await post("employer/COC_list_JOb", jobcoc.toJson());
    return response.body;
  }

  Future<JobCoc> updateJobCOC(JobCoc jobcoc) async {
    final response = await httpPatch(
        "employer/COC_list_JOb_update/${jobcoc.id}", jobcoc.toJson());
    return JobCoc.fromJson(response);
  }

  Future<int?> deleteJobCOC(JobCoc jobcoc) async {
    final response =
        await delete("employer/COC_list_JOb_retrieve_destroy/${jobcoc.id}");
    return response.statusCode;
  }
}

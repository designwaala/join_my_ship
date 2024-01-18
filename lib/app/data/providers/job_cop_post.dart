import 'package:join_my_ship/app/data/models/job_model.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

class JobCOPPostProvider extends WrapperConnect {
  JobCOPPostProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return JobCop.fromJson(map);
      if (map is List) return map.map((item) => JobCop.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<JobCop> postJobCOP(JobCop jobcop) async {
    final response = await post("employer/COP_list_JOb", jobcop.toJson());
    return response.body;
  }

  Future<JobCop> updateJobCOP(JobCop jobcop) async {
    final response = await httpPatch(
        "employer/COP_list_JOb_update/${jobcop.id}", jobcop.toJson());
    return JobCop.fromJson(response);
  }

  Future<int?> deleteJobCOP(JobCop jobcop) async {
    final response =
        await delete("employer/COP_list_JOb_retrieve_destroy/${jobcop.id}");
    return response.statusCode;
  }
}

// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:join_my_ship/main.dart';
// import 'package:join_my_ship/utils/wrapper_connect.dart';

// import '../models/job_post_model.dart';

// class JobPostProvider extends WrapperConnect {
//   JobPostProvider() {
//     httpClient.defaultDecoder = (map) {
//       if (map is Map<String, dynamic>) return JobPost.fromJson(map);
//       if (map is List) {
//         return map.map((item) => JobPost.fromJson(item)).toList();
//       }
//     };
//     httpClient.baseUrl = baseURL;
//   }

//   Future<List<JobPost>> getJobPosts({required int employerId}) async {
//     // final response = await get('jobpost/$id');
//     // return response.body;
//     String json = await rootBundle.loadString("assets/job_post.json");
//     List<JobPost> jobPosts = [];
//     for (dynamic obj in const JsonCodec().decode(json)) {
//       jobPosts.add(JobPost.fromJson(obj));
//     }
//     jobPosts.add(jobPosts[0]);
//     jobPosts.add(jobPosts[0]);
//     return jobPosts;
//   }

//   Future<Response<JobPost>> postJobPost(JobPost jobpost) async =>
//       await post('jobpost', jobpost);
//   Future<Response> deleteJobPost(int id) async => await delete('jobpost/$id');
// }

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';

import '../models/job_application_model.dart';

class JobApplicationProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return JobApplication.fromJson(map);
      if (map is List) {
        return map.map((item) => JobApplication.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<JobApplication>?> getJobApplications({int? id}) async {
    // final response = await get('jobapplication/$id');
    // return response.body;
    String json = await rootBundle.loadString("assets/job_application.json");
    List<JobApplication> jobApplications = [];
    for (dynamic obj in const JsonCodec().decode(json)) {
      jobApplications.add(JobApplication.fromJson(obj));
    }
    jobApplications.add(jobApplications[0]);
    jobApplications.add(jobApplications[0]);
    return jobApplications;
  }

  Future<Response<JobApplication>> postJobApplication(
          JobApplication jobapplication) async =>
      await post('jobapplication', jobapplication);
  Future<Response> deleteJobApplication(int id) async =>
      await delete('jobapplication/$id');
}

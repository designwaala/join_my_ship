import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/error.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../../../main.dart';
import '../models/crew_user_model.dart';
import 'package:http/http.dart' as http;

class CrewUserProvider extends WrapperConnect {
  CrewUserProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return CrewUser.fromJson(map);
      if (map is List)
        return map.map((item) => CrewUser.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<CrewUser?> getCrewUser({bool softRefresh = false}) async {
    final response = await get('crew/get_user', softRefresh: softRefresh);
    UserStates.instance.crewUser = response.body;
    return response.body;
  }

  Future<int> createCrewUser(
      {required CrewUser crewUser,
      String? profilePicPath,
      String? resumePath}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://designwaala.me/crew/user_create'));
    request.fields.addAll(crewUser.toJson());
    if (resumePath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('resume', resumePath));
    }
    if (profilePicPath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('profilePic', profilePicPath));
    }

    request.headers.addAll({
      "Content-Type":
          "multipart/form-data; boundary=<calculated when request is sent>"
    });

    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (streamedResponse.statusCode < 300) {
      // print(await streamedResponse.stream.bytesToString());
    } else {
      // print(streamedResponse.reasonPhrase);
      APIErrorList errors = APIErrorList.fromJson(jsonDecode(response.body));
      Get.showSnackbar(GetSnackBar(
        title: "Some error occurred",
        messageText: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errors.apiErrorList
                    ?.map((error) => [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(error.field ?? "",
                                  style: Get.theme.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.white)),
                              4.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...?error.errors?.map((e) => Text(e,
                                      style: Get.theme.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.white))),
                                ],
                              )
                            ],
                          ),
                          4.verticalSpace
                        ])
                    .expand((element) => element)
                    .toList() ??
                []),
      ));
    }
    return streamedResponse.statusCode;
  }

  Future<int> updateCrewUser(
      {required int crewId,
      CrewUser? crewUser,
      String? profilePicPath,
      String? resumePath}) async {
    var request = http.MultipartRequest(
        'PATCH', Uri.parse('https://designwaala.me/crew/user_update/$crewId'));
    if (crewUser != null) {
      request.fields.addAll(crewUser.toJson());
    }
    if (resumePath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('resume', resumePath));
    }
    if (profilePicPath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('profilePic', profilePicPath));
    }

    request.headers.addAll({
      "Content-Type":
          "multipart/form-data; boundary=<calculated when request is sent>",
      "Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"
    });

    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (streamedResponse.statusCode < 300) {
      // print(await streamedResponse.stream.bytesToString());
    } else {
      print(streamedResponse.reasonPhrase);
    }
    return streamedResponse.statusCode;
  }
}

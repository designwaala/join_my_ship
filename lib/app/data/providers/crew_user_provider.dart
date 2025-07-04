import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/error.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';
import 'package:join_my_ship/widgets/top_modal_sheet.dart';

import '../../../main.dart';
import '../models/crew_user_model.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

class CrewUserProvider extends WrapperConnect {
  CrewUserProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic> && map['count'] != null) return CrewUserList.fromJson(map);
      if (map is Map<String, dynamic>) return CrewUser.fromJson(map);
      if (map is List)
        return map.map((item) => CrewUser.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<CrewUser?> getJobApplicant(int userId) async {
    final response = await get("crew/user_retrieve/$userId",
        decoder: (map) => CrewUser.fromJson(map));
    return response.body;
  }

  Future<CrewUser?> getCrewUser({bool softRefresh = false}) async {
    final response = await get<CrewUser>('crew/get_user',
        softRefresh: softRefresh, decoder: (map) => CrewUser.fromJson(map));
    UserStates.instance.crewUser = response.body;
    if (response.body?.id != null) {
      FirebaseCrashlytics.instance
          .setUserIdentifier(response.body!.id!.toString());
      await PreferencesHelper.instance.setUserId(response.body!.id!);
      await PreferencesHelper.instance.setUserCode(response.body?.userCode);
    }
    if (response.body?.userTypeKey != null) {
      await PreferencesHelper.instance
          .setIsCrew(response.body?.userTypeKey == 2);
    }
    return response.body;
  }

  Future<int> createCrewUser(
      {required CrewUser crewUser,
      String? profilePicPath,
      String? resumePath}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://joinmyship.com/crew/user_create'));
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
      //id is not responded from this API
      /* UserStates.instance.crewUser =
          CrewUser.fromJson(jsonDecode(response.body));
      if (UserStates.instance.crewUser?.id != null) {
        await PreferencesHelper.instance
            .setUserId(UserStates.instance.crewUser!.id!);
      } */
      // print(await streamedResponse.stream.bytesToString());
    } else {
      // print(streamedResponse.reasonPhrase);
      APIErrorList errors = APIErrorList.fromJson(jsonDecode(response.body));
      showTopModalSheet(
          Get.context!,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Some error occurred", style: Get.textTheme.titleMedium),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: errors.apiErrorList
                            ?.map((error) => [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${error.field ?? ""}:",
                                          style:
                                              Get.theme.textTheme.bodyMedium),
                                      4.horizontalSpace,
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...?error.errors?.map((e) => Text(e,
                                                maxLines: 3,
                                                style: Get
                                                    .theme.textTheme.bodyMedium
                                                    ?.copyWith())),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  4.verticalSpace
                                ])
                            .expand((element) => element)
                            .toList() ??
                        []),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(onPressed: Get.back, child: Text("OK")),
                )
              ],
            ),
          ));
    }
    return streamedResponse.statusCode;
  }

  Future<int?> updateCrewUser(
      {required int crewId,
      CrewUser? crewUser,
      String? profilePicPath,
      String? resumePath}) async {
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }
    var response = await _updateCrewUserCore(
        crewId: crewId,
        crewUser: crewUser,
        profilePicPath: profilePicPath,
        resumePath: resumePath);
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await _updateCrewUserCore(
          crewId: crewId,
          crewUser: crewUser,
          profilePicPath: profilePicPath,
          resumePath: resumePath);
      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await _updateCrewUserCore(
            crewId: crewId,
            crewUser: crewUser,
            profilePicPath: profilePicPath,
            resumePath: resumePath);
        if (response.statusCode == 401) {
          signOut();
        } else if ((response.statusCode ?? 0) >= 300) {
          APIErrorList errors =
              APIErrorList.fromJson(jsonDecode(response.body));
          showTopModalSheet(
              Get.context!,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Some error occurred",
                        style: Get.textTheme.titleMedium),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: errors.apiErrorList
                                ?.map((error) => [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${error.field ?? ""}:",
                                              style: Get
                                                  .theme.textTheme.bodyMedium),
                                          4.horizontalSpace,
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...?error.errors?.map((e) =>
                                                    Text(e,
                                                        maxLines: 3,
                                                        style: Get
                                                            .theme
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith())),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      4.verticalSpace
                                    ])
                                .expand((element) => element)
                                .toList() ??
                            []),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                          onPressed: Get.back, child: Text("OK")),
                    )
                  ],
                ),
              ));
        } else {
          UserStates.instance.crewUser =
              CrewUser.fromJson(jsonDecode(response.body));
        }
      } else if (response.statusCode <= 200) {
        UserStates.instance.crewUser =
            CrewUser.fromJson(jsonDecode(response.body));
      }
    } else if (response.statusCode <= 200) {
      UserStates.instance.crewUser =
          CrewUser.fromJson(jsonDecode(response.body));
    }
    return response.statusCode;
  }

  Future<http.Response> _updateCrewUserCore(
      {required int crewId,
      CrewUser? crewUser,
      String? profilePicPath,
      String? resumePath}) async {
    var request = http.MultipartRequest(
        'PATCH', Uri.parse('https://joinmyship.com/crew/user_update/$crewId'));
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
      /* APIErrorList errors = APIErrorList.fromJson(jsonDecode(response.body));
      showTopModalSheet(
          Get.context!,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Some error occurred", style: Get.textTheme.titleMedium),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: errors.apiErrorList
                            ?.map((error) => [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${error.field ?? ""}:",
                                          style:
                                              Get.theme.textTheme.bodyMedium),
                                      4.horizontalSpace,
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...?error.errors?.map((e) => Text(e,
                                                maxLines: 3,
                                                style: Get
                                                    .theme.textTheme.bodyMedium
                                                    ?.copyWith())),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  4.verticalSpace
                                ])
                            .expand((element) => element)
                            .toList() ??
                        []),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(onPressed: Get.back, child: Text("OK")),
                )
              ],
            ),
          )); */
    }
    return response;
  }

  Future<List<CrewUser>> getFeaturedCompanies() async {
    final response = await get("crew/user_priority_list");
    return response.body;
  }

  Future<List<CrewUser>> getAllCompanies() async {
    final response = await get("crew/company_list");
    return response.body;
  }

  Future<List<CrewUser>> findCompany(String companyName) async {
    final response = await get("crew/search_filter",
        query: {"search_type": "1", "search_key": companyName});
    return response.body;
  }

  Future<CrewUserList?> findCrewByRank(String rank) async {
    final response = await get("crew/search_filter",
        query: {"search_type": "2", "search_key": rank});
    return response.body;
  }

  Future<CrewUser?> createSubUser(String email) async {
    final response =
        await multipartPost("crew/referral_create_user", {"email": email});
    return CrewUser.fromJson(response);
  }

  Future<List<CrewUser>?> fetchSubUserDetails(String userLink) async {
    final response = await get<List<CrewUser>?>("crew/referral_list/$userLink/",
        headers: {}, decoder: (map) {
      return List<CrewUser>.from(map.map((x) => CrewUser.fromJson(x)));
    });
    UserStates.instance.crewUser = response.body?.firstOrNull;
    return response.body;
  }

  Future<List<CrewUser>?> getSubUsers() async {
    final response =
        await get("crew/manage_user_list/${PreferencesHelper.instance.userId}");
    return response.body;
  }

  Future<int?> deleteUser(int id) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final statusCode = await multipartDelete(
        "crew/user_retrieve_destroy/$id", {"auth_key": idToken ?? ""});
    if (statusCode == 204) {
      // ContinuousStream().emit(Streams.userDeleted, id);
    }
    return statusCode;
  }

  Future<int?> deleteSubUser(int userId) async =>
      (await delete("crew/user_retrieve_destroy/$userId")).statusCode;
}

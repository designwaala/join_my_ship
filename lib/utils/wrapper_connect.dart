import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/error.dart';
import 'package:join_mp_ship/app/data/models/login_model.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:join_mp_ship/widgets/top_modal_sheet.dart';

class WrapperConnect extends GetConnect {
  signOut() async {
    await FirebaseAuth.instance.signOut();
    await PreferencesHelper.instance.clearAll();
    Get.offAllNamed(Routes.INFO);
  }

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      bool softRefresh = false}) async {
    print(PreferencesHelper.instance.accessToken);
    // if (PreferencesHelper.instance.userCreated != true) {
    //   return await super.get<T>(
    //     url,
    //     headers: headers ??
    //         {
    //           "Authorization":
    //               "Bearer ${PreferencesHelper.instance.accessToken}"
    //         },
    //     contentType: contentType,
    //     query: query,
    //     decoder: decoder,
    //   );
    // }
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      bool didGetAccessTokens = await getAccessTokens();
      if (!didGetAccessTokens && softRefresh) {
        return Response<T>();
      }
    }
    var response = await super.get<T>(
      url,
      headers: headers ??
          {"Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"},
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await super.get<T>(
        url,
        headers: headers ??
            {
              "Authorization":
                  "Bearer ${PreferencesHelper.instance.accessToken}"
            },
        contentType: contentType,
        query: query,
        decoder: decoder,
      );

      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await super.get<T>(
          url,
          headers: headers ??
              {
                "Authorization":
                    "Bearer ${PreferencesHelper.instance.accessToken}"
              },
          contentType: contentType,
          query: query,
          decoder: decoder,
        );
        if (response.statusCode == 401) {
          signOut();
        } else if ((response.statusCode ?? 0) >= 300) {
          APIErrorList errors =
              APIErrorList.fromJson(jsonDecode(response.bodyString ?? ""));
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
        }
      }
    }

    return response;
  }

  Future<bool> getAccessTokens() async {
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await super.post(
      "myadmin_api/log_in/",
      {},
      headers: {"Authorization": "Bearer $idToken"},
      decoder: (map) {
        try {
          return Login.fromJson(map);
        } catch (e) {
          print("$e");
        }
      },
    );
    await Future.wait([
      PreferencesHelper.instance.setAccessToken(response.body?.data?.access),
      PreferencesHelper.instance.setRefreshToken(response.body?.data?.refresh)
    ]);
    return response.body != null;
  }

  Future<void> refreshAccessToken() async {
    final response = await http.post(
      Uri.parse("http://designwaala.me/myadmin_api/api/login/refresh/"),
      body: {"refresh": PreferencesHelper.instance.refreshToken},
    );
    final data = Data.fromJson(jsonDecode(response.body));
    await PreferencesHelper.instance.setAccessToken(data.access);
  }

  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }
    var response = await super.post<T>(
      url,
      body,
      headers: headers ??
          {"Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"},
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await super.post<T>(
        url,
        body,
        headers: headers ??
            {
              "Authorization":
                  "Bearer ${PreferencesHelper.instance.accessToken}"
            },
        contentType: contentType,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await super.post<T>(
          url,
          body,
          headers: headers ??
              {
                "Authorization":
                    "Bearer ${PreferencesHelper.instance.accessToken}"
              },
          contentType: contentType,
          query: query,
          decoder: decoder,
          uploadProgress: uploadProgress,
        );
        if (response.statusCode == 401) {
          signOut();
        } else if ((response.statusCode ?? 0) >= 300) {
          APIErrorList errors =
              APIErrorList.fromJson(jsonDecode(response.bodyString ?? ""));
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
        }
      }
    }
    return response;
  }

  Future<Map<String, dynamic>> multipartPatch(String url, dynamic body,
      {Map<String, dynamic>? headers}) async {
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }
    var response = await _multipartPatchCore(url, body);
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await _multipartPatchCore(url, body);
      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await _multipartPatchCore(url, body);
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
        }
      }
    }
    return jsonDecode(response.body);
  }

  Future<http.Response> _multipartPatchCore(String url, dynamic body,
      {Map<String, String>? headers}) async {
    var request = http.MultipartRequest('PATCH', Uri.parse("$baseURL/$url"));
    request.fields.addAll(body is Map ? body : body.toJson());

    headers ??= {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"
    };

    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    if (streamedResponse.statusCode == 200) {
      // print(await streamedResponse.stream.bytesToString());
    } else {
      print(streamedResponse.reasonPhrase);
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> httpPatch<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }

    var response = await http.patch(Uri.parse("$baseURL/$url"),
        body: body is Map ? jsonEncode(body) : body,
        headers: headers ??
            {
              "Content-Type": "multipart/form-data",
              "Authorization":
                  "Bearer ${PreferencesHelper.instance.accessToken}"
            });
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await http.patch(Uri.parse("$baseURL/$url"),
          body: jsonEncode(body),
          headers: headers ??
              {
                "Content-Type": "multipart/form-data",
                "Authorization":
                    "Bearer ${PreferencesHelper.instance.accessToken}"
              });

      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await http.patch(Uri.parse("$baseURL/$url"),
            body: jsonEncode(body),
            headers: headers ??
                {
                  "Content-Type": "multipart/form-data",
                  "Authorization":
                      "Bearer ${PreferencesHelper.instance.accessToken}"
                });

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
        }
      }
    }
    return jsonDecode(response.body);
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }
    var response = await super.delete(
      url,
      headers: headers ??
          {"Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"},
      contentType: contentType,
      query: query,
      decoder: decoder,
    );

    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await super.delete(
        url,
        headers: headers ??
            {
              "Authorization":
                  "Bearer ${PreferencesHelper.instance.accessToken}"
            },
        contentType: contentType,
        query: query,
        decoder: decoder,
      );
      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await super.delete(
          url,
          headers: headers ??
              {
                "Authorization":
                    "Bearer ${PreferencesHelper.instance.accessToken}"
              },
          contentType: contentType,
          query: query,
          decoder: decoder,
        );
        if (response.statusCode == 401) {
          signOut();
        } else if ((response.statusCode ?? 0) >= 300) {
          APIErrorList errors =
              APIErrorList.fromJson(jsonDecode(response.bodyString ?? ""));
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
        }
      }
    }
    return response;
  }
}

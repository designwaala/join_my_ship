import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/error.dart';
import 'package:join_my_ship/app/data/models/login_model.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/string_extensions.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:join_my_ship/widgets/top_modal_sheet.dart';

class WrapperConnect extends GetConnect {
  signOut() async {
    await FirebaseAuth.instance.signOut();
    await PreferencesHelper.instance.clearAll();
    Get.offAllNamed(Routes.INFO);
  }

/*   Future<http.Response> _rawGetCore(String url,
      {Map<String, String>? headers}) async {
    FirebaseCrashlytics.instance.log("Making GET request $url}");
    var request = http.Request('GET', Uri.parse("$baseURL/$url"));
    request.headers.addAll(headers ?? {});
    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    FirebaseCrashlytics.instance
        .log("GET Response $url ${response.body} ${response.statusCode}");
    return response;
  } */

/*   Future<dynamic> rawGet<T>(String url,
      {Map<String, String>? headers, bool softRefresh = false}) async {
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      bool didGetAccessTokens = await getAccessTokens();
      if (!didGetAccessTokens && softRefresh) {
        return null;
      }
    }
    var response = await _rawGetCore(url, headers: headers);
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await _rawGetCore(url, headers: headers);

      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await _rawGetCore(url, headers: headers);
        if (response.statusCode == 401) {
          signOut();
        } else if ((response.statusCode ?? 0) >= 300) {}
      }
    }

    return jsonDecode(response.body);
  } */

  Future<dynamic> httpGet<T>(
      {Uri? uri,
      String? url,
      Map<String, String>? headers,
      bool softRefresh = false}) async {
    FirebaseCrashlytics.instance.log(
        "Making GET request $url ${uri?.queryParameters.keys.map((e) => "$e:${uri.queryParameters[e]}").join(", ")}");
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      bool didGetAccessTokens = await getAccessTokens();
      if (!didGetAccessTokens && softRefresh) {
        return null;
      }
    }
    var response = await http.get(
      uri ?? Uri.parse("$baseURL/$url"),
      headers: headers ??
          {"Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"},
    );
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await http.get(
        uri ?? Uri.parse("$baseURL/$url"),
        headers: headers ??
            {
              "Authorization":
                  "Bearer ${PreferencesHelper.instance.accessToken}"
            },
      );

      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await http.get(uri ?? Uri.parse("$baseURL/$url"),
            headers: headers ??
                {
                  "Authorization":
                      "Bearer ${PreferencesHelper.instance.accessToken}"
                });
        if (response.statusCode == 401) {
          signOut();
        } else if ((response.statusCode ?? 0) >= 300) {}
      }
    }
    FirebaseCrashlytics.instance
        .log("GET Response $url ${response.body} ${response.statusCode}");
    return jsonDecode(response.body);
  }

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      bool softRefresh = false}) async {
    FirebaseCrashlytics.instance.log(
        "Making GET request $url ${query?.keys.map((e) => "$e:${query[e]}").join(", ")}");
    print(PreferencesHelper.instance.accessToken);
    if (headers == null && PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      bool didGetAccessTokens = await getAccessTokens();
      if (!didGetAccessTokens && softRefresh) {
        return Response<T>();
      }
    }
    var response = await _getCore<T>(
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
      response = await _getCore<T>(
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
        response = await _getCore<T>(
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
    FirebaseCrashlytics.instance
        .log("GET Response $url ${response.bodyString} ${response.statusCode}");
    return response;
  }

  Future<Response<T>> _getCore<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    var response = await super.get<dynamic>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: (data) => data,
      // decoder: decoder,
    );
    if (response.bodyString?.nullIfEmpty() != null) {
      try {
        jsonDecode(response.bodyString ?? "");
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(Exception("Unable to parse response from $url GET API ${RemoteConfigUtils.instance.retrySlashAPICall ? "Retrying": "Not Retrying"}"), st);
        if (RemoteConfigUtils.instance.retrySlashAPICall) {
          String correctedUrl = url.substring(url.length - 1) == "/" ? url.substring(0, url.length - 1) : "$url/";
          response = await super.get<dynamic>(
            correctedUrl,
            headers: headers,
            contentType: contentType,
            query: query,
            decoder: decoder ?? httpClient.defaultDecoder,
          );
        }
      }
    }
    return Response(
    request: response.request,
    statusCode: response.statusCode,
    bodyBytes: response.bodyBytes,
    bodyString: response.bodyString,
    statusText: response.statusText,
    headers: response.headers,
    body: decoder?.call(jsonDecode(response.bodyString ?? "")) ?? httpClient.defaultDecoder?.call(jsonDecode(response.bodyString ?? ""))
    );
  }

  Future<bool> getAccessTokens() async {
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) {
      await FirebaseAuth.instance.signOut();
      await PreferencesHelper.instance.clearAll();
      Get.offAllNamed(Routes.INFO);
      return false;
    }
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
      Uri.parse("https://joinmyship.com/myadmin_api/api/login/refresh/"),
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
    FirebaseCrashlytics.instance.log(
        "Making POST request $url ${body is Map ? body.keys.map((e) => "$e:${body[e]}").join(", ") : body}");
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }
    var response = await _postCore<T>(
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
      response = await _postCore<T>(
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
        response = await _postCore<T>(
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
    FirebaseCrashlytics.instance.log(
        "POST Response $url ${response.bodyString} ${response.statusCode}");
    return response;
  }

  Future<Response<T>> _postCore<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    var response = await super.post<dynamic>(
      url,
      body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: (data) => data,
      uploadProgress: uploadProgress,
    );
    if (response.bodyString?.nullIfEmpty() != null) {
      try {
        jsonDecode(response.bodyString ?? "");
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(Exception("Unable to parse response from $url POST API ${RemoteConfigUtils.instance.retrySlashAPICall ? "Retrying": "Not Retrying"}"), st);
        if (RemoteConfigUtils.instance.retrySlashAPICall) {
          String correctedUrl = (url?.substring(url.length - 1) == "/" ? url?.substring(0, url.length - 1) : "$url/") ?? "";
          response = await super.post<dynamic>(
            correctedUrl,
            body,
            headers: headers,
            contentType: contentType,
            query: query,
            decoder: decoder ?? httpClient.defaultDecoder,
            uploadProgress: uploadProgress,
          );
        }
      }
    }
    return Response(
      request: response.request,
      statusCode: response.statusCode,
      bodyBytes: response.bodyBytes,
      bodyString: response.bodyString,
      statusText: response.statusText,
      headers: response.headers,
      body: decoder?.call(jsonDecode(response.bodyString ?? "")) ?? httpClient.defaultDecoder?.call(jsonDecode(response.bodyString ?? ""))
    );
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
    FirebaseCrashlytics.instance.log(
        "Making PATCH request $url ${body is Map ? body.keys.map((e) => "$e:${body[e]}").join(", ") : body}");
    var request = http.MultipartRequest('PATCH', Uri.parse("$baseURL/$url"));
    request.fields.addAll(body is Map ? body : body.toJson());

    headers ??= {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"
    };

    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.body.nullIfEmpty() != null) {
      try {
        jsonDecode(response.body);
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(Exception("Unable to parse response from $url PATCH API ${RemoteConfigUtils.instance.retrySlashAPICall ? "Retrying": "Not Retrying"}"), st);
        if (RemoteConfigUtils.instance.retrySlashAPICall) {
          String correctedUrl = url.substring(url.length - 1) == "/" ? url.substring(0, url.length - 1) : "$url/";
          request = http.MultipartRequest('PATCH', Uri.parse("$baseURL$correctedUrl"));
          request.fields.addAll(body is Map ? body : body.toJson());
          request.headers.addAll(headers);
          http.StreamedResponse streamedResponse = await request.send();
          response = await http.Response.fromStream(streamedResponse);
        }
    }
    }
    if (streamedResponse.statusCode == 200) {
      // print(await streamedResponse.stream.bytesToString());
    } else {
      print(streamedResponse.reasonPhrase);
    }
    FirebaseCrashlytics.instance
        .log("PATCH Response $url ${response.body} ${response.statusCode}");
    return response;
  }

  Future<Map<String, dynamic>> multipartPost(String url, dynamic body,
      {Map<String, String>? headers}) async {
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }
    var response = await _multipartPostCore(url, body, headers: headers);
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await _multipartPostCore(url, body, headers: headers);
      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await _multipartPostCore(url, body, headers: headers);
        if (response.statusCode == 401) {
          signOut();
        } else if ((response.statusCode ?? 0) >= 300) {
          _showError(response.body);
        }
      }
    } else if (response.statusCode == 402) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: Text(
                  jsonDecode(response.body)['message'] ?? "Payment Required"),
              actions: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: StadiumBorder()),
                    onPressed: Get.back,
                    child: Text("OK")),
                const SizedBox(width: 8),
                FilledButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(Routes.SUBSCRIPTIONS);
                    },
                    child: const Text("Buy Credits"))
              ],
            );
          });
    } else if (response.statusCode >= 300) {
      _showError(response.body);
    }
    return jsonDecode(response.body);
  }

  _showError(String error) {
    APIErrorList errors = APIErrorList.fromJson(jsonDecode(error));
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${error.field ?? ""}:",
                                        style: Get.theme.textTheme.bodyMedium),
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

  Future<http.Response> _multipartPostCore(String url, dynamic body,
      {Map<String, String>? headers}) async {
    FirebaseCrashlytics.instance.log(
        "Making POST request $url ${body is Map ? body.keys.map((e) => "$e:${body[e]}").join(", ") : body}");
    var request = http.MultipartRequest('POST', Uri.parse("$baseURL$url"));
    request.fields.addAll(body is Map ? body : body.toJson());

    headers ??= {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"
    };

    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.body.nullIfEmpty() != null) {
      try {
        jsonDecode(response.body);
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(Exception("Unable to parse response from $url POST API ${RemoteConfigUtils.instance.retrySlashAPICall ? "Retrying": "Not Retrying"}"), st);
        if (RemoteConfigUtils.instance.retrySlashAPICall) {
          String correctedUrl = url.substring(url.length - 1) == "/" ? url.substring(0, url.length - 1) : "$url/";
          request = http.MultipartRequest('POST', Uri.parse("$baseURL$correctedUrl"));
          request.fields.addAll(body is Map ? body : body.toJson());
          request.headers.addAll(headers);
          http.StreamedResponse streamedResponse = await request.send();
          response = await http.Response.fromStream(streamedResponse);
        }
      }
    }

    if (streamedResponse.statusCode == 200) {
      // print(await streamedResponse.stream.bytesToString());
    } else {
      print(streamedResponse.reasonPhrase);
    }
    FirebaseCrashlytics.instance
        .log("POST Response $url ${response.body} ${response.statusCode}");
    return response;
  }

  Future<Map<String, dynamic>> httpPatch<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    FirebaseCrashlytics.instance.log(
        "Making PATCH request $url ${body is Map ? body.keys.map((e) => "$e:${body[e]}").join(", ") : body}");
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }

    var response = await _httpPatchCore("$baseURL$url",
        body, // is Map ? jsonEncode(body) : body,
        headers: headers ??
            {
              "Content-Type": "multipart/form-data",
              "Authorization":
                  "Bearer ${PreferencesHelper.instance.accessToken}"
            });
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await _httpPatchCore("$baseURL/$url",
          jsonEncode(body),
          headers: headers ??
              {
                "Content-Type": "multipart/form-data",
                "Authorization":
                    "Bearer ${PreferencesHelper.instance.accessToken}"
              });

      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await _httpPatchCore("$baseURL$url",
            jsonEncode(body),
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
    FirebaseCrashlytics.instance
        .log("PATCH Response $url ${response.body} ${response.statusCode}");
    return jsonDecode(response.body);
  }

  Future<http.Response> _httpPatchCore(
    String? url,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    var response = await http.patch(Uri.parse("$baseURL$url"),
        body: body,
        headers: headers ??
            {
              "Content-Type": "multipart/form-data",
              "Authorization":
                  "Bearer ${PreferencesHelper.instance.accessToken}"
      });
    
    if (response.body.nullIfEmpty() != null) {
      try {
        jsonDecode(response.body);
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(Exception("Unable to parse response from $url PATCH API ${RemoteConfigUtils.instance.retrySlashAPICall ? "Retrying": "Not Retrying"}"), st);
        if (RemoteConfigUtils.instance.retrySlashAPICall) {
        String correctedUrl = (url?.substring(url.length - 1) == "/" ? url?.substring(0, url.length - 1) : "$url/") ?? "";
        response = await http.patch(Uri.parse("$baseURL$correctedUrl"),
          body: body,
          headers: headers ??
              {
                "Content-Type": "multipart/form-data",
                "Authorization":
                    "Bearer ${PreferencesHelper.instance.accessToken}"
        });
        }
      }
    } 
    return response;
  }
  
  @override
  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    FirebaseCrashlytics.instance.log("Making DELETE request $url");
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }
    var response = await _deleteCore(
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
      response = await _deleteCore(
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
        response = await _deleteCore(
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
    FirebaseCrashlytics.instance
        .log("DELETE Response $url ${response.body} ${response.statusCode}");
    return response;
  }

  Future<Response<T>> _deleteCore<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    var response = await super.delete<dynamic>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: (data) => data,
    );
    if (response.bodyString?.nullIfEmpty() != null) {
      try {
        jsonDecode(response.bodyString ?? "");
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(Exception("Unable to parse response from $url DELETE API ${RemoteConfigUtils.instance.retrySlashAPICall ? "Retrying": "Not Retrying"}"), st);
        if (RemoteConfigUtils.instance.retrySlashAPICall) {
          String correctedUrl = url.substring(url.length - 1) == "/" ? url.substring(0, url.length - 1) : "$url/";
          response = await super.delete<dynamic>(
            correctedUrl,
            headers: headers,
            contentType: contentType,
            query: query,
            decoder: decoder ?? httpClient.defaultDecoder,
          );
        }
      }
    }
    return Response(
      request: response.request,
      statusCode: response.statusCode,
      bodyBytes: response.bodyBytes,
      bodyString: response.bodyString,
      statusText: response.statusText,
      headers: response.headers,
    );
  }
  
  Future<int?> multipartDelete(String url, dynamic body,
      {Map<String, dynamic>? headers}) async {
    print(PreferencesHelper.instance.accessToken);
    if (PreferencesHelper.instance.accessToken.isEmpty) {
      print("Access Token not found, getting them");
      await getAccessTokens();
    }
    var response = await _multipartDeleteCore(url, body);
    if (response.statusCode == 401) {
      print("Refreshing Access Token");
      await refreshAccessToken();
      response = await _multipartDeleteCore(url, body);
      if (response.statusCode == 401) {
        print("Refreshing Access Token didnt work, getting new Tokens");
        await getAccessTokens();
        response = await _multipartDeleteCore(url, body);
        if (response.statusCode == 401) {
          signOut();
        } else if ((response.statusCode ?? 0) >= 300) {
          _showError(response.body);
        }
      }
    } else if (response.statusCode == 402) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: Text(
                  jsonDecode(response.body)['message'] ?? "Payment Required"),
              actions: [
                OutlinedButton(onPressed: Get.back, child: Text("OK")),
                const SizedBox(width: 8),
                FilledButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(Routes.SUBSCRIPTIONS);
                    },
                    child: const Text("Buy Credits"))
              ],
            );
          });
    } else if (response.statusCode >= 300) {
      _showError(response.body);
    }
    return response.statusCode;
  }

  Future<http.Response> _multipartDeleteCore(String url, dynamic body,
      {Map<String, String>? headers}) async {
    var request = http.MultipartRequest('DELETE', Uri.parse("$baseURL$url"));
    request.fields.addAll(body is Map ? body : body.toJson());

    headers ??= {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"
    };

    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.body.nullIfEmpty() != null) {
      try {
        jsonDecode(response.body);
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(Exception("Unable to parse response from $url DELETE API ${RemoteConfigUtils.instance.retrySlashAPICall ? "Retrying": "Not Retrying"}"), st);
        if (RemoteConfigUtils.instance.retrySlashAPICall) {
          String correctedUrl = url.substring(url.length - 1) == "/" ? url.substring(0, url.length - 1) : "$url/";
          request = http.MultipartRequest('DELETE', Uri.parse("$baseURL$correctedUrl"));
          request.fields.addAll(body is Map ? body : body.toJson());
          request.headers.addAll(headers);
          http.StreamedResponse streamedResponse = await request.send();
          response = await http.Response.fromStream(streamedResponse);
        }
      }
    }
    if (streamedResponse.statusCode == 200) {
      // print(await streamedResponse.stream.bytesToString());
    } else {
      print(streamedResponse.reasonPhrase);
    }
    return response;
  }
}

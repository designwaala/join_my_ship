import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/login_model.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WrapperConnect extends GetConnect {
  _signOut() async {
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
          _signOut();
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
          _signOut();
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
          _signOut();
        }
      }
    }
    return response;
  }
}

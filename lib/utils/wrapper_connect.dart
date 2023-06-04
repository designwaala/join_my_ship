import 'package:get/get.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';

class WrapperConnect extends GetConnect {
  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) {
    headers ??= {};
    headers.addAll(
        {"Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"});
    print(PreferencesHelper.instance.accessToken);
    return super.get<T>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
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
    headers ??= {};
    headers.addAll(
        {"Authorization": "Bearer ${PreferencesHelper.instance.accessToken}"});
    print(PreferencesHelper.instance.accessToken);
    final response = await super.post<T>(
      url,
      body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
    return response;
  }
}

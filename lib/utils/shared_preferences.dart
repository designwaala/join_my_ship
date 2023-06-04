import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  PreferencesHelper._();
  static final PreferencesHelper instance = PreferencesHelper._();

  SharedPreferences? _sharedPreferences;

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  String _ACCESS_TOKEN = 'access-token', _REFRESH_TOKEN = "refresh-token";

  Future<void> setAccessToken(String? value) =>
      value == null || _sharedPreferences == null
          ? Future.value(null)
          : _sharedPreferences!.setString(_ACCESS_TOKEN, value);
  String get accessToken => _sharedPreferences?.getString(_ACCESS_TOKEN) ?? "";

  Future<void> setRefreshToken(String? value) =>
      value == null || _sharedPreferences == null
          ? Future.value(null)
          : _sharedPreferences!.setString(_REFRESH_TOKEN, value);
  String get refreshToken =>
      _sharedPreferences?.getString(_REFRESH_TOKEN) ?? "";
}

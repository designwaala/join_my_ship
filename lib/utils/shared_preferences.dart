import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  PreferencesHelper._();
  static final PreferencesHelper instance = PreferencesHelper._();

  SharedPreferences? _sharedPreferences;

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  String ACCESS_TOKEN = 'access-token', REFRESH_TOKEN = "refresh-token";

  set accessToken(String? value) =>
      value == null ? null : _sharedPreferences?.setString(ACCESS_TOKEN, value);
  String get accessToken => _sharedPreferences?.getString(ACCESS_TOKEN) ?? "";

  set refreshToken(String? value) => value == null
      ? null
      : _sharedPreferences?.setString(REFRESH_TOKEN, value);
  String get refreshToken => _sharedPreferences?.getString(REFRESH_TOKEN) ?? "";
}

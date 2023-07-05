import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  PreferencesHelper._();
  static final PreferencesHelper instance = PreferencesHelper._();

  SharedPreferences? _sharedPreferences;

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool>? clearAll() {
    return _sharedPreferences?.clear();
  }

  String _ACCESS_TOKEN = 'access-token',
      _REFRESH_TOKEN = "refresh-token",
      _USER_CREATED = "user-created",
      _COMPANY_NAME = "company_name",
      _WEBSITE = "webiste";

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

  bool? get userCreated => _sharedPreferences?.getBool(_USER_CREATED);
  Future<bool>? setUserCreated(value) =>
      _sharedPreferences?.setBool(_USER_CREATED, value);

  String? get companyName => _sharedPreferences?.getString(_COMPANY_NAME);
  Future<void>? setCompanyName(value) =>
      _sharedPreferences?.setString(_COMPANY_NAME, value);

  String? get website => _sharedPreferences?.getString(_WEBSITE);
  Future<void>? setWebsite(value) =>
      _sharedPreferences?.setString(_WEBSITE, value);
}

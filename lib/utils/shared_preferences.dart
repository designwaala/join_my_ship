import 'package:join_my_ship/utils/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:join_my_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';

class PreferencesHelper {
  PreferencesHelper._();
  static final PreferencesHelper instance = PreferencesHelper._();

  SharedPreferences? _sharedPreferences;

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> reload() async {
    return await _sharedPreferences?.reload();
  }

  Future<bool>? clearAll() {
    UserStates.instance.reset();
    return _sharedPreferences?.clear();
  }

  String _ACCESS_TOKEN = 'access-token',
      _REFRESH_TOKEN = "refresh-token",
      _USER_CREATED = "user-created",
      _COMPANY_NAME = "company_name",
      _WEBSITE = "webiste",
      _IS_CREW = "is-crew",
      _USER_ID = "user-id",
      _USER_DETAIL_ID = "user-detail-id",
      _FCM_TOKEN = "fcm-token",
      _EMPLOYER_TYPE = "employer-type",
      _USER_LINK = "user-link";

  int? get userDetailId => _sharedPreferences?.getInt(_USER_DETAIL_ID);
  Future<bool>? setUserDetailId(value) =>
      _sharedPreferences?.setInt(_USER_DETAIL_ID, value);

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

  bool? get isCrew => _sharedPreferences?.getBool(_IS_CREW);
  Future<void>? setIsCrew(bool value) =>
      _sharedPreferences?.setBool(_IS_CREW, value);

  int? get userId => _sharedPreferences?.getInt(_USER_ID);
  Future<void>? setUserId(int value) =>
      _sharedPreferences?.setInt(_USER_ID, value);

  String? get localFCMToken => _sharedPreferences?.getString(_FCM_TOKEN);
  Future<void>? setFCMToken(String value) =>
      _sharedPreferences?.setString(_FCM_TOKEN, value);

  SignUpType? get employerType {
    switch (_sharedPreferences?.getInt(_EMPLOYER_TYPE)) {
      case 2:
        return SignUpType.crew;
      case 3:
        return SignUpType.employerITF;
      case 4:
        return SignUpType.employerManagementCompany;
      case 5:
        return SignUpType.employerCrewingAgent;
    }
  }

  Future<void>? setEmployerType(int value) =>
      _sharedPreferences?.setInt(_EMPLOYER_TYPE, value);

  String? get userLink => _sharedPreferences?.getString(_USER_LINK);
  Future<void>? setUserLink(String userLink) =>
      _sharedPreferences?.setString(_USER_LINK, userLink);
  Future<bool> clearUserLink() =>
      _sharedPreferences?.remove(_USER_LINK) ?? Future.value(false);
}

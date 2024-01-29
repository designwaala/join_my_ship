import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:join_my_ship/app/data/models/credits_model.dart';
import 'package:join_my_ship/app/data/models/info_model.dart';

class RemoteConfigUtils {
  RemoteConfigUtils._();
  static final RemoteConfigUtils instance = RemoteConfigUtils._();

  static FirebaseRemoteConfig? _remoteConfig;

  static Future<FirebaseRemoteConfig> getRemoteConfig() async {
    if (_remoteConfig == null) {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 6),
      ));
      await _remoteConfig?.fetchAndActivate();
    }
    return _remoteConfig!;
  }

  String get accountUnderVerificationCopy =>
      _remoteConfig?.getString("account_under_verification_copy") ??
      "Account Under Verification";

  bool? get longPressToLogOut =>
      _remoteConfig?.getBool("long_press_to_log_out");

  CreditsModel? get creditsModel =>
      _remoteConfig?.getString("credits_model") == null
          ? null
          : CreditsModel.fromJson(
              jsonDecode(_remoteConfig!.getString("credits_model")));

  bool? get razorpayKeyTest => _remoteConfig?.getBool("razorpay_key_test");

  List<InfoModel>? get info => _remoteConfig?.getString("info_screen") == null
      ? null
      : List<InfoModel>.from(jsonDecode(_remoteConfig!.getString("info_screen"))
          .map((e) => InfoModel.fromJson(e)));
}

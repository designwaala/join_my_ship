import 'package:firebase_remote_config/firebase_remote_config.dart';

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
      _remoteConfig?.getString("account_under_verification_copy") ?? "Account Under Verification";

  bool? get longPressToLogOut =>
      _remoteConfig?.getBool("long_press_to_log_out");
}

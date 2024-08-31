import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:join_my_ship/app/data/models/credits_model.dart';
import 'package:join_my_ship/app/data/models/info_model.dart';
import 'package:join_my_ship/app/data/models/job_post_top_up_packs.dart';
import 'package:join_my_ship/utils/extensions/string_extensions.dart';

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

  bool? get intentionalCrash => _remoteConfig?.getBool("intentional_crash");

  List<JobPostTopUpPack>? get jobPostTopUpPacks =>
      _remoteConfig?.getString("job_post_top_up_packs").nullIfEmpty() == null
          ? null
          : List<JobPostTopUpPack>.from(
              jsonDecode(_remoteConfig!.getString("job_post_top_up_packs"))
                  .map((e) => JobPostTopUpPack.fromJson(e)));

  List<String> get iosProductIds {
    List<String> defaultProductIds = ["goldplan", "silverplan", "platinumplan"];
    if (_remoteConfig?.getString("ios_product_ids") == null) {
      return defaultProductIds;
    } else {
      final decodedResponse =
          jsonDecode(_remoteConfig!.getString("ios_product_ids"));
      if (decodedResponse["product_ids"] == null) {
        return defaultProductIds;
      } else {
        return List<String>.from(
            decodedResponse["product_ids"].map((e) => "$e"));
      }
    }
  }

  bool get showDeleteAccountButton =>
      _remoteConfig?.getBool("show_delete_account_button") ?? true;

  bool get showEditEmailButton =>
      _remoteConfig?.getBool("show_edit_email_button") ?? true;

  bool get enableInAppReviewAndroid =>
      _remoteConfig?.getBool("enable_in_app_review_android") ?? false;

  bool get retrySlashAPICall =>
      _remoteConfig?.getBool("retry_slash_api_call") ?? false;

  bool get showDiscover =>
      _remoteConfig?.getBool("show_discover") ?? false;
}

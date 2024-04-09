import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:join_my_ship/app/data/providers/application_provider.dart';
import 'package:join_my_ship/app/data/providers/applied_refer_code_provider.dart';
import 'package:join_my_ship/app/data/providers/boosting_provider.dart';
import 'package:join_my_ship/app/data/providers/cdc_issuing_authority_provider.dart';
import 'package:join_my_ship/app/data/providers/check_referral_code_apply_provider.dart';
import 'package:join_my_ship/app/data/providers/coc_provider.dart';
import 'package:join_my_ship/app/data/providers/cop_provider.dart';
import 'package:join_my_ship/app/data/providers/country_provider.dart';
import 'package:join_my_ship/app/data/providers/credit_provider.dart';
import 'package:join_my_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_my_ship/app/data/providers/current_job_post_provider.dart';
import 'package:join_my_ship/app/data/providers/employer_counts_provider.dart';
import 'package:join_my_ship/app/data/providers/fcm_token_provider.dart';
import 'package:join_my_ship/app/data/providers/flag_provider.dart';
import 'package:join_my_ship/app/data/providers/follow_provider.dart';
import 'package:join_my_ship/app/data/providers/highlight_provider.dart';
import 'package:join_my_ship/app/data/providers/job_application_provider.dart';
import 'package:join_my_ship/app/data/providers/job_post_plan_top_up_provider.dart';
import 'package:join_my_ship/app/data/providers/job_post_provider.dart';
import 'package:join_my_ship/app/data/providers/job_coc_post.dart';
import 'package:join_my_ship/app/data/providers/job_cop_post.dart';
import 'package:join_my_ship/app/data/providers/job_provider.dart';
import 'package:join_my_ship/app/data/providers/job_rank_with_wages_provider.dart';
import 'package:join_my_ship/app/data/providers/job_share_provider.dart';
import 'package:join_my_ship/app/data/providers/job_watch_keeping_post.dart';
import 'package:join_my_ship/app/data/providers/liked_post_provider.dart';
import 'package:join_my_ship/app/data/providers/login_provider.dart';
import 'package:join_my_ship/app/data/providers/notification_provider.dart';
import 'package:join_my_ship/app/data/providers/order_provider.dart';
import 'package:join_my_ship/app/data/providers/passport_issuing_authority_provider.dart';
import 'package:join_my_ship/app/data/providers/point_history_provider.dart';
import 'package:join_my_ship/app/data/providers/previous_employer_provider.dart';
import 'package:join_my_ship/app/data/providers/ranks_provider.dart';
import 'package:join_my_ship/app/data/providers/resume_pack_buy_provider.dart';
import 'package:join_my_ship/app/data/providers/resume_pack_provider.dart';
import 'package:join_my_ship/app/data/providers/resume_top_up_buy_provider.dart';
import 'package:join_my_ship/app/data/providers/resume_top_up_provider.dart';
import 'package:join_my_ship/app/data/providers/sea_service_provider.dart';
import 'package:join_my_ship/app/data/providers/secondary_users_provider.dart';
import 'package:join_my_ship/app/data/providers/state_provider.dart';
import 'package:join_my_ship/app/data/providers/stcw_issuing_authority_provider.dart';
import 'package:join_my_ship/app/data/providers/subscription_provider.dart';
import 'package:join_my_ship/app/data/providers/user_code_provider.dart';
import 'package:join_my_ship/app/data/providers/user_details_provider.dart';
import 'package:join_my_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_my_ship/app/data/providers/vessel_type_provider.dart';
import 'package:join_my_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_my_ship/app/modules/job_opening/controllers/job_opening_controller.dart';
import 'package:join_my_ship/firebase_options.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/toasts/unfocus_gesture.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uni_links/uni_links.dart';

import 'app/routes/app_pages.dart';

String baseURL = "";
String razorpayKey = "";

GetIt getIt = GetIt.instance;
PackageInfo? packageInfo;

final alertDialogShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(24));

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}

void main() async {
  baseURL = "https://joinmyship.com/";
  runZonedGuarded<Future<void>>(() async {
    HttpOverrides.global = MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug:
            true, // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl:
            true // option: set to false to disable working with http links (default: false)
        );
    //
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.instance.requestPermission();
    StreamSubscription<String?>? uriStream;
    notificationListeners();
    uriStream = linkStream.listen((event) {
      Uri uri = Uri.parse(event ?? "");
      _handleLink(uri);
    });
    //
    await RemoteConfigUtils.getRemoteConfig();
    packageInfo = await PackageInfo.fromPlatform();
    await PreferencesHelper.instance.init();
    razorpayKey = RemoteConfigUtils.instance.razorpayKeyTest == true
        ? "rzp_test_wwDObsaedPI1ni"
        : "rzp_live_BbEn6GJzJKOWvT";
    if (!kDebugMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    runApp(ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) {
          return UnFocusGesture(
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            theme: ThemeData(
                    scaffoldBackgroundColor:
                        const Color.fromRGBO(251, 246, 255, 1),
                    textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme))
                .copyWith(
                    colorScheme: Get.theme.colorScheme.copyWith(
                        tertiary: const Color(0xFFFE9738),
                        background: const Color.fromRGBO(251, 246, 255, 1))),
          ));
        }));
  }, (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });

  getIt
    ..registerSingleton(LoginProvider())
    ..registerSingleton(RanksProvider())
    ..registerSingleton(CrewUserProvider())
    ..registerSingleton(CountryProvider())
    ..registerSingleton(StateProvider())
    ..registerSingleton(UserDetailsProvider())
    ..registerSingleton(VesselTypeProvider())
    ..registerSingleton(SeaServiceProvider())
    ..registerSingleton(PreviousEmployerProvider())
    ..registerSingleton(VesselListProvider())
    ..registerSingleton(SecondaryUsersProvider())
    ..registerSingleton(CocProvider())
    ..registerSingleton(CopProvider())
    ..registerSingleton(WatchKeepingProvider())
    ..registerSingleton(JobApplicationProvider())
    ..registerSingleton(JobProvider())
    ..registerSingleton(JobCOCPostProvider())
    ..registerSingleton(JobCOPPostProvider())
    ..registerSingleton(JobWatchKeepingPostProvider())
    ..registerSingleton(JobRankWithWagesProvider())
    ..registerSingleton(ApplicationProvider())
    ..registerSingleton(PassportIssuingAuthorityProvider())
    ..registerSingleton(CdcIssuingAuthorityProvider())
    ..registerSingleton(StcwIssuingAuthorityProvider())
    ..registerSingleton(FollowProvider())
    ..registerSingleton(FcmTokenProvider())
    ..registerSingleton(LikedPostProvider())
    ..registerSingleton(EmployerCountsProvider())
    ..registerSingleton(HighlightProvider())
    ..registerSingleton(SubscriptionProvider())
    ..registerSingleton(BoostingProvider())
    ..registerSingleton(FlagProvider())
    ..registerSingleton(ResumePackProvider())
    ..registerSingleton(ResumePackBuyProvider())
    ..registerSingleton(ResumeTopUpProvider())
    ..registerSingleton(ResumeTopUpBuyProvider())
    ..registerSingleton(NotificationProvider())
    ..registerSingleton(OrderProvider())
    ..registerSingleton(CreditProvider())
    ..registerSingleton(PointHistoryProvider())
    ..registerSingleton(CurrentJobPostProvider())
    ..registerSingleton(JobPostPlanTopUpProvider())
    ..registerSingleton(UserCodeProvider())
    ..registerSingleton(AppliedReferCodeProvider())
    ..registerSingleton(JobShareProvider())
    ..registerSingleton(CheckReferralCodeApplyProvider());
}

notificationListeners() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
    if (event.data["post_id"] != null) {
      Get.toNamed(Routes.JOB_OPENING,
          arguments: JobOpeningArguments(
              jobId: int.tryParse(event.data["post_id"] ?? "")),
          preventDuplicates: false);
    }
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    if (PreferencesHelper.instance.localFCMToken != newToken) {
      getIt<FcmTokenProvider>()
          .postFCMToken(newToken)
          .then((value) => PreferencesHelper.instance.setFCMToken(newToken));
    }
  });
}

_handleLink(Uri uri) async {
  switch (uri.path.split("/")[1]) {
    case "new-user":
      UserStates.instance.isCrew = false;
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: alertDialogShape,
              title: Text("Please wait while we fetch your details"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          });
      UserStates.instance.userLink = uri.path.split("/").last;
      PreferencesHelper.instance.setUserLink(uri.path.split("/").last);
      await getIt<CrewUserProvider>()
          .fetchSubUserDetails(uri.path.split("/").last);
      Get.back();
      Get.toNamed(Routes.CHOOSE_EMPLOYER, preventDuplicates: false);
  }
}

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Please wait while we fetch your details"),
        16.verticalSpace,
        CircularProgressIndicator()
      ],
    );
  }
}

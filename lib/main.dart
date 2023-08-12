import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:join_mp_ship/app/data/providers/application_provider.dart';
import 'package:join_mp_ship/app/data/providers/cdc_issuing_authority_provider.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_application_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_post_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_coc_post.dart';
import 'package:join_mp_ship/app/data/providers/job_cop_post.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_rank_with_wages_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_watch_keeping_post.dart';
import 'package:join_mp_ship/app/data/providers/login_provider.dart';
import 'package:join_mp_ship/app/data/providers/passport_issuing_authority_provider.dart';
import 'package:join_mp_ship/app/data/providers/previous_employer_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/sea_service_provider.dart';
import 'package:join_mp_ship/app/data/providers/secondary_users_provider.dart';
import 'package:join_mp_ship/app/data/providers/state_provider.dart';
import 'package:join_mp_ship/app/data/providers/stcw_issuing_authority_provider.dart';
import 'package:join_mp_ship/app/data/providers/user_details_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_type_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/firebase_options.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/widgets/toasts/unfocus_gesture.dart';

import 'app/routes/app_pages.dart';

String baseURL = "";

GetIt getIt = GetIt.instance;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PreferencesHelper.instance.init();
  try {
    print(await FirebaseAuth.instance.currentUser?.getIdToken());
  } catch (e) {
    await FirebaseAuth.instance.signOut();
    PreferencesHelper.instance.clearAll();
  }
  baseURL = "https://designwaala.me/";
  runApp(
    ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) {
          return UnFocusGesture(
              child: GetMaterialApp(
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
                        background: const Color.fromRGBO(251, 246, 255, 1))),
          ));
        }),
  );

  getIt
    ..registerSingleton(LoginProvider())
    ..registerSingleton(RanksProvider())
    ..registerSingleton(CrewUserProvider())
    ..registerSingleton(CountryProvider())
    ..registerSingleton(StateProvider())
    // ..registerSingleton(ServiceRecordProvider())
    // ..registerSingleton(PreviousEmployerReferenceProvider())
    ..registerSingleton(UserDetailsProvider())
    ..registerSingleton(VesselTypeProvider())
    ..registerSingleton(SeaServiceProvider())
    ..registerSingleton(PreviousEmployerProvider())
    ..registerSingleton(VesselListProvider())
    ..registerSingleton(SecondaryUsersProvider())
    ..registerSingleton(CocProvider())
    ..registerSingleton(CopProvider())
    ..registerSingleton(WatchKeepingProvider())
    // ..registerSingleton(JobPostProvider())
    ..registerSingleton(JobApplicationProvider())
    ..registerSingleton(JobProvider())
    ..registerSingleton(JobCOCPostProvider())
    ..registerSingleton(JobCOPPostProvider())
    ..registerSingleton(JobWatchKeepingPostProvider())
    ..registerSingleton(JobRankWithWagesProvider())
    ..registerSingleton(ApplicationProvider())
    ..registerSingleton(PassportIssuingAuthorityProvider())
    ..registerSingleton(CdcIssuingAuthorityProvider())
    ..registerSingleton(StcwIssuingAuthorityProvider());
}

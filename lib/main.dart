import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/login_provider.dart';
import 'package:join_mp_ship/app/data/providers/previous_employer_reference_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/service_record_provider.dart';
import 'package:join_mp_ship/app/data/providers/state_provider.dart';
import 'package:join_mp_ship/app/data/providers/user_details_provider.dart';
import 'package:join_mp_ship/firebase_options.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/widgets/toasts/unfocus_gesture.dart';

import 'app/routes/app_pages.dart';

String baseURL = "";

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print(await FirebaseAuth.instance.currentUser?.getIdToken());
  baseURL = "https://designwaala.me/";
  PreferencesHelper.instance.init();
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
                textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            )),
          ));
        }),
  );

  getIt
    ..registerSingleton(LoginProvider())
    ..registerSingleton(RanksProvider())
    ..registerSingleton(CrewUserProvider())
    ..registerSingleton(CountryProvider())
    ..registerSingleton(StateProvider())
    ..registerSingleton(ServiceRecordProvider())
    ..registerSingleton(PreviousEmployerReferenceProvider())
    ..registerSingleton(UserDetailsProvider());
}

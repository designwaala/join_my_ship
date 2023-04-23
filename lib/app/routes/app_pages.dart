import 'package:get/get.dart';

import '../modules/choose_user/bindings/choose_user_binding.dart';
import '../modules/choose_user/views/choose_user_view.dart';
import '../modules/crew_sign_in_email/bindings/crew_sign_in_binding.dart';
import '../modules/crew_sign_in_email/views/crew_sign_in_view.dart';
import '../modules/crew_sign_in_mobile/bindings/crew_sign_in_mobile_binding.dart';
import '../modules/crew_sign_in_mobile/views/crew_sign_in_mobile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/info/bindings/info_binding.dart';
import '../modules/info/views/info_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.INFO,
      page: () => const InfoView(),
      binding: InfoBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_USER,
      page: () => const ChooseUserView(),
      binding: ChooseUserBinding(),
    ),
    GetPage(
      name: _Paths.CREW_SIGN_IN_EMAIL,
      page: () => const CrewSignInEmailView(),
      binding: CrewSignInBinding(),
    ),
    GetPage(
      name: _Paths.CREW_SIGN_IN_MOBILE,
      page: () => const CrewSignInMobileView(),
      binding: CrewSignInMobileBinding(),
    ),
  ];
}

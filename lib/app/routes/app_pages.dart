import 'package:get/get.dart';

import '../modules/account_under_verification/bindings/account_under_verification_binding.dart';
import '../modules/account_under_verification/views/account_under_verification_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/choose_employer/bindings/choose_employer_binding.dart';
import '../modules/choose_employer/views/choose_employer_view.dart';
import '../modules/choose_user/bindings/choose_user_binding.dart';
import '../modules/choose_user/views/choose_user_view.dart';
import '../modules/crew-onboarding/bindings/crew_onboarding_binding.dart';
import '../modules/crew-onboarding/views/crew_onboarding_view.dart';
import '../modules/crew_sign_in_email/bindings/crew_sign_in_binding.dart';
import '../modules/crew_sign_in_email/views/crew_sign_in_view.dart';
import '../modules/crew_sign_in_mobile/bindings/crew_sign_in_mobile_binding.dart';
import '../modules/crew_sign_in_mobile/views/crew_sign_in_mobile_view.dart';
import '../modules/email_verification_waiting/bindings/email_verification_waiting_binding.dart';
import '../modules/email_verification_waiting/views/email_verification_waiting_view.dart';
import '../modules/employer_create_user/bindings/employer_create_user_binding.dart';
import '../modules/employer_create_user/views/employer_create_user_view.dart';
import '../modules/employer_invite_new_members/bindings/employer_invite_new_members_binding.dart';
import '../modules/employer_invite_new_members/views/employer_invite_new_members_view.dart';
import '../modules/employer_manage_users/bindings/employer_manage_users_binding.dart';
import '../modules/employer_manage_users/views/employer_manage_users_view.dart';
import '../modules/help/bindings/help_binding.dart';
import '../modules/help/views/help_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/info/bindings/info_binding.dart';
import '../modules/info/views/info_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/sign_up_email/bindings/sign_up_email_binding.dart';
import '../modules/sign_up_email/views/sign_up_email_view.dart';
import '../modules/sign_up_phone_number/bindings/sign_up_phone_number_binding.dart';
import '../modules/sign_up_phone_number/views/sign_up_phone_number_view.dart';
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
      bindings: [HomeBinding(), ProfileBinding()],
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
    GetPage(
      name: _Paths.SIGN_UP_EMAIL,
      page: () => const SignUpEmailView(),
      binding: SignUpEmailBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_EMPLOYER,
      page: () => const ChooseEmployerView(),
      binding: ChooseEmployerBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP_PHONE_NUMBER,
      page: () => const SignUpPhoneNumberView(),
      binding: SignUpPhoneNumberBinding(),
    ),
    GetPage(
      name: _Paths.CREW_ONBOARDING,
      page: () => const CrewOnboardingView(),
      binding: CrewOnboardingBinding(),
    ),
    GetPage(
      name: _Paths.EMAIL_VERIFICATION_WAITING,
      page: () => const EmailVerificationWaitingView(),
      binding: EmailVerificationWaitingBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_UNDER_VERIFICATION,
      page: () => const AccountUnderVerificationView(),
      binding: AccountUnderVerificationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HELP,
      page: () => const HelpView(),
      binding: HelpBinding(),
    ),
    GetPage(
      name: _Paths.EMPLOYER_CREATE_USER,
      page: () => const EmployerCreateUserView(),
      binding: EmployerCreateUserBinding(),
    ),
    GetPage(
      name: _Paths.EMPLOYER_INVITE_NEW_MEMBERS,
      page: () => const EmployerInviteNewMembersView(),
      binding: EmployerInviteNewMembersBinding(),
    ),
    GetPage(
      name: _Paths.EMPLOYER_MANAGE_USERS,
      page: () => const EmployerManageUsersView(),
      binding: EmployerManageUsersBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
  ];
}

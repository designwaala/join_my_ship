import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../widgets/toasts/unfocus_gesture.dart';
import '../modules/account_under_verification/bindings/account_under_verification_binding.dart';
import '../modules/account_under_verification/views/account_under_verification_view.dart';
import '../modules/applicant_detail/bindings/applicant_detail_binding.dart';
import '../modules/applicant_detail/views/applicant_detail_view.dart';
import '../modules/application_status/bindings/application_status_binding.dart';
import '../modules/application_status/views/application_status_view.dart';
import '../modules/boosted_crew_profiles/bindings/boosted_crew_profiles_binding.dart';
import '../modules/boosted_crew_profiles/views/boosted_crew_profiles_view.dart';
import '../modules/boosted_jobs/bindings/boosted_jobs_binding.dart';
import '../modules/boosted_jobs/views/boosted_jobs_view.dart';
import '../modules/boosting/bindings/boosting_binding.dart';
import '../modules/boosting/views/boosting_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/choose_employer/bindings/choose_employer_binding.dart';
import '../modules/choose_employer/views/choose_employer_view.dart';
import '../modules/choose_user/bindings/choose_user_binding.dart';
import '../modules/choose_user/views/choose_user_view.dart';
import '../modules/companies/bindings/companies_binding.dart';
import '../modules/companies/views/companies_view.dart';
import '../modules/company_detail/bindings/company_detail_binding.dart';
import '../modules/company_detail/views/company_detail_view.dart';
import '../modules/connectivity_lost/bindings/connectivity_lost_binding.dart';
import '../modules/connectivity_lost/views/connectivity_lost_view.dart';
import '../modules/crew-onboarding/bindings/crew_onboarding_binding.dart';
import '../modules/crew-onboarding/views/crew_onboarding_view.dart';
import '../modules/crew_detail/bindings/crew_detail_binding.dart';
import '../modules/crew_detail/views/crew_detail_view.dart';
import '../modules/crew_job_applications/bindings/crew_job_applications_binding.dart';
import '../modules/crew_job_applications/views/crew_job_applications_view.dart';
import '../modules/crew_list/bindings/crew_list_binding.dart';
import '../modules/crew_list/views/crew_list_view.dart';
import '../modules/crew_referral/bindings/crew_referral_binding.dart';
import '../modules/crew_referral/views/crew_referral_view.dart';
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
import '../modules/employer_job_applications/bindings/employer_job_applications_binding.dart';
import '../modules/employer_job_applications/views/employer_job_applications_view.dart';
import '../modules/employer_job_posts/bindings/employer_job_posts_binding.dart';
import '../modules/employer_job_posts/views/employer_job_posts_view.dart';
import '../modules/employer_manage_users/bindings/employer_manage_users_binding.dart';
import '../modules/employer_manage_users/views/employer_manage_users_view.dart';
import '../modules/error_occurred/bindings/error_occurred_binding.dart';
import '../modules/error_occurred/views/error_occurred_view.dart';
import '../modules/follow/bindings/followings_binding.dart';
import '../modules/follow/views/followings_view.dart';
import '../modules/help/bindings/help_binding.dart';
import '../modules/help/views/help_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/info/bindings/info_binding.dart';
import '../modules/info/views/info_view.dart';
import '../modules/job_applied_successfully/bindings/job_applied_successfully_binding.dart';
import '../modules/job_applied_successfully/views/job_applied_successfully_view.dart';
import '../modules/job_opening/bindings/job_opening_binding.dart';
import '../modules/job_opening/views/job_opening_view.dart';
import '../modules/job_openings/bindings/job_openings_binding.dart';
import '../modules/job_openings/views/job_openings_view.dart';
import '../modules/job_post/bindings/job_post_binding.dart';
import '../modules/job_post/views/job_post_view.dart';
import '../modules/job_posted_successfully/bindings/job_posted_successfully_binding.dart';
import '../modules/job_posted_successfully/views/job_posted_successfully_view.dart';
import '../modules/liked_jobs/bindings/liked_jobs_binding.dart';
import '../modules/liked_jobs/views/liked_jobs_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_email_verification_view.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/sign_up_email/bindings/sign_up_email_binding.dart';
import '../modules/sign_up_email/views/sign_up_email_view.dart';
import '../modules/sign_up_phone_number/bindings/sign_up_phone_number_binding.dart';
import '../modules/sign_up_phone_number/views/sign_up_phone_number_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subscriptions/bindings/subscriptions_binding.dart';
import '../modules/subscriptions/views/subscriptions_view.dart';
import '../modules/success/bindings/success_binding.dart';
import '../modules/success/views/success_view.dart';
import '../modules/view_jobs_posted/bindings/view_jobs_posted_binding.dart';
import '../modules/view_jobs_posted/views/view_jobs_posted_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => const HomeView(), bindings: [
      HomeBinding(),
      BoostingBinding(),
      ProfileBinding(),
      JobOpeningsBinding(),
    ], middlewares: [
      ConnectivityMiddleWare()
    ]),
    GetPage(
        name: _Paths.SPLASH,
        page: () => const SplashView(),
        binding: SplashBinding()),
    GetPage(
        name: _Paths.INFO,
        page: () => const InfoView(),
        binding: InfoBinding()),
    GetPage(
        name: _Paths.CHOOSE_USER,
        page: () => const ChooseUserView(),
        binding: ChooseUserBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.CREW_SIGN_IN_EMAIL,
        page: () => const CrewSignInEmailView(),
        binding: CrewSignInBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.CREW_SIGN_IN_MOBILE,
        page: () => const CrewSignInMobileView(),
        binding: CrewSignInMobileBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.SIGN_UP_EMAIL,
        page: () => const SignUpEmailView(),
        binding: SignUpEmailBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.CHOOSE_EMPLOYER,
        page: () => const ChooseEmployerView(),
        binding: ChooseEmployerBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.SIGN_UP_PHONE_NUMBER,
        page: () => const SignUpPhoneNumberView(),
        binding: SignUpPhoneNumberBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.CREW_ONBOARDING,
        page: () => const CrewOnboardingView(),
        binding: CrewOnboardingBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.EMAIL_VERIFICATION_WAITING,
        page: () => const EmailVerificationWaitingView(),
        binding: EmailVerificationWaitingBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.ACCOUNT_UNDER_VERIFICATION,
        page: () => const AccountUnderVerificationView(),
        binding: AccountUnderVerificationBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.PROFILE,
        page: () => const ProfileView(),
        binding: ProfileBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.HELP,
        page: () => const HelpView(),
        binding: HelpBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.EMPLOYER_CREATE_USER,
        page: () => const EmployerCreateUserView(),
        binding: EmployerCreateUserBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.EMPLOYER_INVITE_NEW_MEMBERS,
        page: () => const EmployerInviteNewMembersView(),
        binding: EmployerInviteNewMembersBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.EMPLOYER_MANAGE_USERS,
        page: () => const EmployerManageUsersView(),
        binding: EmployerManageUsersBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.CHANGE_PASSWORD,
        page: () => const ChangePasswordView(),
        binding: ChangePasswordBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.RESET_PASSWORD,
        page: () => const ResetPasswordView(),
        binding: ResetPasswordBinding(),
        middlewares: [ConnectivityMiddleWare()]),
/*     GetPage(
      name: _Paths.RESET_PASSWORD_EMAIL_VERIFICATION,
      page: () => const ResetPasswordEmailVerificationView(),
      binding: ResetPasswordBinding(),
    ), */
    GetPage(
        name: _Paths.JOB_POST,
        page: () => const JobPostView(),
        binding: JobPostBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.JOB_POSTED_SUCCESSFULLY,
        page: () => const JobPostedSuccessfullyView(),
        binding: JobPostedSuccessfullyBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.VIEW_JOBS_POSTED,
        page: () => const ViewJobsPostedView(),
        binding: ViewJobsPostedBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.EMPLOYER_JOB_POSTS,
        page: () => const EmployerJobPostsView(),
        binding: EmployerJobPostsBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.EMPLOYER_JOB_APPLICATIONS,
        page: () => const EmployerJobApplicationsView(),
        binding: EmployerJobApplicationsBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.JOB_OPENINGS,
        page: () => const JobOpeningsView(),
        binding: JobOpeningsBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.JOB_APPLIED_SUCCESSFULLY,
        page: () => const JobAppliedSuccessfullyView(),
        binding: JobAppliedSuccessfullyBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.SUCCESS,
        page: () => const SuccessView(),
        binding: SuccessBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.CREW_JOB_APPLICATIONS,
        page: () => const CrewJobApplicationsView(),
        binding: CrewJobApplicationsBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.APPLICANT_DETAIL,
        page: () => const ApplicantDetailView(),
        binding: ApplicantDetailBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.APPLICATION_STATUS,
        page: () => const ApplicationStatusView(),
        binding: ApplicationStatusBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
        name: _Paths.ERROR_OCCURRED,
        page: () => const ErrorOccurredView(),
        binding: ErrorOccurredBinding(),
        middlewares: [ConnectivityMiddleWare()]),
    GetPage(
      name: _Paths.JOB_OPENING,
      page: () => const JobOpeningView(),
      binding: JobOpeningBinding(),
      middlewares: [ConnectivityMiddleWare()],
    ),
    GetPage(
      name: _Paths.CONNECTIVITY_LOST,
      page: () => const ConnectivityLostView(),
      binding: ConnectivityLostBinding(),
    ),
    GetPage(
      name: _Paths.COMPANIES,
      page: () => const CompaniesView(),
      binding: CompaniesBinding(),
    ),
    GetPage(
      name: _Paths.COMPANY_DETAIL,
      page: () => const CompanyDetailView(),
      binding: CompanyDetailBinding(),
    ),
    GetPage(
      name: _Paths.FOLLOW,
      page: () => const FollowingsView(),
      binding: FollowingsBinding(),
    ),
    GetPage(
      name: _Paths.LIKED_JOBS,
      page: () => const LikedJobsView(),
      binding: LikedJobsBinding(),
    ),
    GetPage(
      name: _Paths.CREW_LIST,
      page: () => const CrewListView(),
      binding: CrewListBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTIONS,
      page: () => const SubscriptionsView(),
      binding: SubscriptionsBinding(),
    ),
    GetPage(
      name: _Paths.BOOSTING,
      page: () => const BoostingView(),
      binding: BoostingBinding(),
    ),
    GetPage(
      name: _Paths.BOOSTED_JOBS,
      page: () => const BoostedJobsView(),
      binding: BoostedJobsBinding(),
    ),
    GetPage(
      name: _Paths.BOOSTED_CREW_PROFILES,
      page: () => const BoostedCrewProfilesView(),
      binding: BoostedCrewProfilesBinding(),
    ),
    GetPage(
      name: _Paths.CREW_DETAIL,
      page: () => const CrewDetailView(),
      binding: CrewDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREW_REFERRAL,
      page: () => const CrewReferralView(),
      binding: CrewReferralBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
  ];
}

class ConnectivityMiddleWare extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) => page;

  @override
  RouteSettings? redirect(String? route) => null;
}

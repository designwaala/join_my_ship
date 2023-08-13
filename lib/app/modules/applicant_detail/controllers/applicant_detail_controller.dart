import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/data/providers/application_provider.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_application_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/user_details_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicantDetailController extends GetxController {
  CrewUser? applicant;
  UserDetails? applicantDetails;
  RxBool isLoading = false.obs;
  List<Rank>? ranks;
  List<Country>? countries;
  RxBool isGettingResume = false.obs;
  RxBool isShortListing = false.obs;

  ApplicantDetailArguments? args;
  Rxn<Application> application = Rxn();

  @override
  void onInit() {
    if (Get.arguments is ApplicantDetailArguments?) {
      args = Get.arguments;
      application.value = args?.application;
    }
    instantiate();
    super.onInit();
  }

  instantiate() async {
    if (args?.userId == null) {
      return;
    }
    isLoading.value = true;
    applicant = await getIt<CrewUserProvider>().getJobApplicant(args!.userId!);
    applicantDetails =
        await getIt<UserDetailsProvider>().getUserDetails(args!.userId!);
    ranks = await getIt<RanksProvider>().getRankList();
    countries = await getIt<CountryProvider>().getCountry();
    isLoading.value = false;
    if (application.value?.viewedStatus != true) {
      getIt<ApplicationProvider>().viewApplication(application.value?.id ?? -1);
    }
  }

  downloadResume() async {
    isGettingResume.value = true;
    String? resume = await getIt<ApplicationProvider>()
        .downloadResumeForApplication(args?.application?.jobId ?? -1,
            args?.application?.userData?.id ?? -1);
    launchUrl(Uri.parse("https://designwaala.me$resume"),
        mode: LaunchMode.externalApplication);
    isGettingResume.value = false;
  }

  shortList() async {
    if (application.value?.shortlistedStatus == true) {
      return;
    }
    isShortListing.value = true;
    application.value = await getIt<ApplicationProvider>()
        .shortListApplication(args?.application?.id ?? -1);
    isShortListing.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }
}

class ApplicantDetailArguments {
  final int? userId;
  final Application? application;
  const ApplicantDetailArguments({this.userId, this.application});
}

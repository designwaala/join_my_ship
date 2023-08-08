import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/user_details_provider.dart';
import 'package:join_mp_ship/main.dart';

class ApplicantDetailController extends GetxController {
  CrewUser? applicant;
  UserDetails? applicantDetails;
  RxBool isLoading = false.obs;
  List<Rank>? ranks;
  List<Country>? countries;

  ApplicantDetailArguments? args;

  @override
  void onInit() {
    if (Get.arguments is ApplicantDetailArguments?) {
      args = Get.arguments;
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

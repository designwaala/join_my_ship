import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/boosting_model.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/user_details_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class CrewDetailController extends GetxController {
  CrewDetailArguments? args;
  UserDetails? crewDetail;
  CrewUser? crew;
  List<Rank>? ranks;
  List<Country>? countries;
  RxBool isLoading = false.obs;
  RxBool isGettingResume = false.obs;

  @override
  void onInit() {
    if (Get.arguments is CrewDetailArguments?) {
      args = Get.arguments;
    }
    getCrew();
    super.onInit();
  }

  Future<void> getCrew() async {
    isLoading.value = true;
    ranks =
        UserStates.instance.ranks ?? await getIt<RanksProvider>().getRankList();
    countries = UserStates.instance.countries ??
        await getIt<CountryProvider>().getCountry();
    // crew = await getIt<CrewUserProvider>().getJobApplicant(args!.crewId!);
    crewDetail = args?.crewDetail;
    crew = args?.crewDetail?.user;
    isLoading.value = false;
  }
  

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class CrewDetailArguments {
  final UserDetails? crewDetail;
  const CrewDetailArguments({this.crewDetail});
}

import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/boosting_model.dart';
import 'package:join_my_ship/app/data/models/country_model.dart';
import 'package:join_my_ship/app/data/models/ranks_model.dart';
import 'package:join_my_ship/app/data/providers/country_provider.dart';
import 'package:join_my_ship/app/data/providers/ranks_provider.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:story_view/controller/story_controller.dart';

class BoostedCrewProfilesController extends GetxController {
  BoostedCrewProfilesArguments? args;
  Crew? boostedCrew;

  RxBool isLoading = false.obs;

  RxList<Rank> ranks = RxList.empty();
  RxList<Country> countries = RxList.empty();

  StoryController storyController = StoryController();

  void onInit() {
    if (Get.arguments is BoostedCrewProfilesArguments?) {
      args = Get.arguments;
    }
    boostedCrew = args?.boostedCrewList?[args?.currentIndex ?? 0];
    init();
    super.onInit();
  }

  init() async {
    isLoading.value = true;
    await loadRanks();
    await loadCountry();
    isLoading.value = false;
  }

  void onReady() {
    super.onReady();
  }

  void onClose() {
    super.onClose();
  }

  Future<void> loadCountry() async {
    countries.value = UserStates.instance.countries ??
        (await getIt<CountryProvider>().getCountry()) ??
        [];
    UserStates.instance.countries = countries;
  }

  Future<void> loadRanks() async {
    ranks.value = UserStates.instance.ranks ??
        (await getIt<RanksProvider>().getRankList()) ??
        [];
    UserStates.instance.ranks = ranks;
  }
}

class BoostedCrewProfilesArguments {
  List<Crew>? boostedCrewList;
  int? currentIndex;

  BoostedCrewProfilesArguments({this.boostedCrewList, this.currentIndex});
}

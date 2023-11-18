import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/boosting_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/providers/boosting_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class BoostingController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<CrewBoostingList> crewBoostings = Rxn();
  Rxn<JobBoostingList> jobBoostings = Rxn();
  Rx<BoostingViewType> view = BoostingViewType.jobPost.obs;
  List<Rank> ranks = [];

  @override
  void onInit() {
    super.onInit();
    getBoostings();
  }

  Future<void> getBoostings() async {
    isLoading.value = true;
    if (view.value == BoostingViewType.jobPost) {
      jobBoostings.value ??= await getIt<BoostingProvider>().getJobBoosting();
    } else {
      crewBoostings.value ??= await getIt<BoostingProvider>().getCrewBoosting();
    }
    ranks = UserStates.instance.ranks ??
        (await getIt<RanksProvider>().getRankList()) ??
        [];
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    view.listen((p0) {
      getBoostings();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}

enum BoostingViewType {
  jobPost,
  profile;

  String get name {
    switch (this) {
      case BoostingViewType.jobPost:
        return "Job Posts";
      case BoostingViewType.profile:
        return "Profile";
    }
  }
}

import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/boosting_model.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:story_view/controller/story_controller.dart';

class BoostedJobsController extends GetxController {
  Rxn<EmployerWithJobs> employerWithJobs = Rxn();
  int currentIndex = 0;
  BoostedJobsArguments? args;

  StoryController storyController = StoryController();

  RxBool isLoading = false.obs;
  VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();

  @override
  void onInit() {
    if (Get.arguments is BoostedJobsArguments?) {
      args = Get.arguments;
    }
    currentIndex = args?.currentIndex ?? 0;
    employerWithJobs.value =
        args?.employerWithJobsList?[args?.currentIndex ?? 0];
    super.onInit();
    initialize();
  }

  initialize() async {
    isLoading.value = true;
    await Future.wait([
      loadVesselTypes(),
      loadRanks(),
      loadCOC(),
      loadCOP(),
      loadWatchKeeping()
    ]);
    isLoading.value = false;
  }

  Future<void> loadVesselTypes() async {
    vesselList = await getIt<VesselListProvider>().getVesselList();
  }

  Future<void> loadRanks() async {
    ranks.value = UserStates.instance.ranks ??
        (await getIt<RanksProvider>().getRankList()) ??
        [];
    UserStates.instance.ranks = ranks;
  }

  Future<void> loadCOC() async {
    cocs.value = (await getIt<CocProvider>().getCOCList(userType: 3)) ?? [];
  }

  Future<void> loadCOP() async {
    cops.value = (await getIt<CopProvider>().getCOPList(userType: 3)) ?? [];
  }

  Future<void> loadWatchKeeping() async {
    watchKeepings.value = (await getIt<WatchKeepingProvider>()
            .getWatchKeepingList(userType: 3)) ??
        [];
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

class BoostedJobsArguments {
  final List<EmployerWithJobs>? employerWithJobsList;
  final int? currentIndex;
  const BoostedJobsArguments({this.employerWithJobsList, this.currentIndex});
}

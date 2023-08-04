import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class EmployerJobPostsController extends GetxController {
  RxList<Job> jobPosts = RxList.empty();
  Rxn<CrewUser> currentEmployerUser = Rxn();
/*   RxMap<int, String> vesselTypes = RxMap();
  RxMap<int, String> rankTypes = RxMap();
  RxMap<int, String> cocTypes = RxMap();
  RxMap<int, String> copTypes = RxMap();
  RxMap<int, String> watchKeepingTypes = RxMap(); */
  VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();

  RxBool isLoading = false.obs;

  RxnInt jobIdBeingDeleted = RxnInt();

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  instantiate() async {
    isLoading.value = true;
    currentEmployerUser.value = UserStates.instance.crewUser ??
        await getIt<CrewUserProvider>().getCrewUser();
    currentEmployerUser.value!.userTypeKey = 3;
    await Future.wait([
      loadJobPosts(),
      loadVesselTypes(),
      loadRanks(),
      loadCOC(userType: currentEmployerUser.value!.userTypeKey!),
      loadCOP(userType: currentEmployerUser.value!.userTypeKey!),
      loadWatchKeeping(userType: currentEmployerUser.value!.userTypeKey!),
    ]);
    isLoading.value = false;
  }

  Future<void> loadJobPosts() async {
    jobPosts.value = (await getIt<JobProvider>()
            .getJobList(employerId: PreferencesHelper.instance.userId ?? -1)) ??
        [];
  }

  Future<void> loadVesselTypes() async {
    vesselList = await getIt<VesselListProvider>().getVesselList();
  }

  Future<void> loadRanks() async {
    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];
  }

  Future<void> loadCOC({required int userType}) async {
    cocs.value = (await getIt<CocProvider>().getCOCList(userType: 3)) ?? [];
  }

  Future<void> loadCOP({required int userType}) async {
    cops.value = (await getIt<CopProvider>().getCOPList(userType: 3)) ?? [];
  }

  Future<void> loadWatchKeeping({required int userType}) async {
    watchKeepings.value = (await getIt<WatchKeepingProvider>()
            .getWatchKeepingList(userType: 3)) ??
        [];
  }

  Future<void> deleteJobPost(int jobId) async {
    jobIdBeingDeleted.value = jobId;
    int? statusCode = await getIt<JobProvider>().deleteJob(jobId);
    if (statusCode == 204) {
      jobPosts.removeWhere((jobPost) => jobPost.id == jobId);
    }
    jobIdBeingDeleted.value = null;
  }
}

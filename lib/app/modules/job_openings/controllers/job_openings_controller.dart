import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/application_provider.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/app/modules/success/controllers/success_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class JobOpeningsController extends GetxController {
  Rxn<CrewUser> currentEmployerUser = Rxn();
  RxList<Job> jobOpenings = RxList.empty();
  VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();

  RxList<int> selectedRanks = RxList.empty();
  RxList<int> selectedVesselTypes = RxList.empty();

  RxList<int> toApplyRanks = RxList.empty();
  RxList<int> toApplyVesselTypes = RxList.empty();

  RxBool isLoading = false.obs;
  RxBool isReferredJob = false.obs;
  RxBool filterOn = false.obs;

  RxnInt applyingJob = RxnInt();

  RxList<Application> applications = RxList.empty();

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  instantiate() async {
    isLoading.value = true;
    currentEmployerUser.value = UserStates.instance.crewUser ??
        await getIt<CrewUserProvider>().getCrewUser();
    await Future.wait([
      loadJobOpenings(),
      loadVesselTypes(),
      loadRanks(),
      loadCOC(),
      loadCOP(),
      loadWatchKeeping(),
      getJobApplications()
    ]);
    isLoading.value = false;
  }

  Future<void> getJobApplications() async {
    applications.value = await getIt<ApplicationProvider>().getAppliedJobList();
  }

  Future<void> applyFilters() async {
    isLoading.value = true;
    await loadJobOpenings();
    isLoading.value = false;
  }

  Future<void> removeFilters() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  Future<void> loadJobOpenings() async {
    jobOpenings.value = (await getIt<JobProvider>().getJobList(
            ranks: selectedRanks, vesselIds: selectedVesselTypes)) ??
        [];
  }

  Future<void> loadVesselTypes() async {
    vesselList = await getIt<VesselListProvider>().getVesselList();
  }

  Future<void> loadRanks() async {
    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];
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

  Future<void> apply(int? jobId) async {
    if (jobId == null) {
      return;
    }
    applyingJob.value = jobId;
    Application? application = await getIt<ApplicationProvider>().apply(
        Application(userId: PreferencesHelper.instance.userId, jobId: jobId));
    if (application?.id == null) {
      applyingJob.value = null;
      return;
    }
    applications.add(application!);
    Get.toNamed(Routes.SUCCESS,
        arguments:
            SuccessArguments(message: "YOU HAVE APPLIED\nSUCCESSFULLY!"));
    applyingJob.value = null;
  }
}

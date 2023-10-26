import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:join_mp_ship/app/data/providers/follow_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/liked_post_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/app/modules/success/controllers/success_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:collection/collection.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class JobOpeningController extends GetxController {
  Rxn<CrewUser> currentEmployerUser = Rxn();
  Rxn<Job> jobOpening = Rxn();
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

  Rxn<MapEntry<int, int>> selectedRank = Rxn();

  RxnInt showErrorForJob = RxnInt();
  RxnInt followingJob = RxnInt();

  final parentKey = GlobalKey();

  final fToast = FToast();

  JobOpeningArguments? args;

  RxBool likingJob = false.obs;

  @override
  void onInit() {
    if (Get.arguments is JobOpeningArguments?) {
      args = Get.arguments;
    }
    instantiate();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
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
      UserStates.instance.crewUser?.userTypeKey == 2
          ? getJobApplications()
          : Future.value(null)
    ]);
    isLoading.value = false;
  }

  Future<void> likeJob() async {
    if (jobOpening.value?.id == null) {
      return;
    }
    likingJob.value = true;
    final response = await getIt<LikedPostProvider>().likePost(jobOpening.value?.id);
    likingJob.value = false;
    if (response.statusCode == 201) {
      fToast.safeShowToast(child: successToast("Job Liked"));
    }
  }

  Future<void> getJobApplications() async {
    applications.value = (await getIt<ApplicationProvider>()
            .getAppliedJobListWithoutJobData()) ??
        [];
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
    if (args?.jobId == null) {
      return;
    }
    jobOpening.value = (await getIt<JobProvider>().getJob(args!.jobId!));
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
        Application(
            userId: PreferencesHelper.instance.userId,
            jobId: jobId,
            rankId: selectedRank.value?.value));
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

  Future<void> followJob(int? theirUserId, int? jobId) async {
    if (theirUserId == null || jobId == null) {
      return;
    }
    followingJob.value = jobId;
    final follow = await getIt<FollowProvider>().follow(theirUserId);
    followingJob.value = null;
    if (follow?.id != null) {
      fToast.safeShowToast(child: successToast("Successfully followed"));
    }
  }
}

class JobOpeningArguments {
  final int? jobId;
  const JobOpeningArguments({this.jobId});
}

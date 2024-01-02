import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/follow_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/liked_post_provider.dart';
import 'package:join_mp_ship/app/modules/success/controllers/success_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class CompanyDetailController extends GetxController {
  CrewUser? employer;
  CompanyDetailArguments? args;
  List<Job> jobs = [];
  RxBool isLoading = false.obs;

  Rxn<CrewUser> currentEmployerUser = Rxn();
  VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();

  RxList<int> selectedRanks = RxList.empty();
  RxList<int> selectedVesselTypes = RxList.empty();

  RxList<int> toApplyRanks = RxList.empty();
  RxList<int> toApplyVesselTypes = RxList.empty();

  RxBool isReferredJob = false.obs;
  RxBool filterOn = false.obs;

  RxnInt applyingJob = RxnInt();

  RxList<Application> applications = RxList.empty();

  Rxn<MapEntry<int, int>> selectedRank = Rxn();

  RxnInt showErrorForJob = RxnInt();
  RxnInt followingJob = RxnInt();

  final parentKey = GlobalKey();

  final fToast = FToast();

  WidgetsToImageController widgetsToImageController =
      WidgetsToImageController();
  Uint8List? bytes;
  RxBool buildCaptureWidget = false.obs;
  RxBool isSharing = false.obs;
  Job? jobToBuild;
  RxnInt likingJob = RxnInt();

  final CountryService _countryService = CountryService();

  List<Country> countryList = [];

  @override
  void onInit() {
    countryList = _countryService.getAll();
    if (Get.arguments is CompanyDetailArguments?) {
      args = Get.arguments;
      employer = args?.employer;
    }
    _getJobsPosted();
    super.onInit();
  }

  Future<void> _getJobsPosted() async {
    if (employer?.id == null) {
      return;
    }
    isLoading.value = true;
    UserStates.instance.countries ??=
        await getIt<CountryProvider>().getCountry();
    jobs =
        (await getIt<JobProvider>().getJobList(employerId: employer?.id)) ?? [];
    await Future.wait([
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

  Future<void> likeJob(int? jobId) async {
    if (jobId == null) {
      return;
    }
    likingJob.value = jobId;
    final response = await getIt<LikedPostProvider>().likePost(jobId);
    likingJob.value = null;
    if (response.statusCode == 201) {
      fToast.safeShowToast(child: successToast("Job Liked"));
    }
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getJobApplications() async {
    applications.value = (await getIt<ApplicationProvider>()
            .getAppliedJobListWithoutJobData()) ??
        [];
  }

  Future<void> removeFilters() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
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
      userId: PreferencesHelper.instance.userId,
      jobId: jobId,
      rankId: selectedRank.value?.value,
    );
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

  Future<void> captureWidget(Job job) async {
    jobToBuild = job;
    buildCaptureWidget.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      bytes = await widgetsToImageController.capture();
      if (bytes == null) {
        Share.share(
            '''
Click on this link to view this Job
http://joinmyship.com/job/?job_id=${job.id}
''');
        buildCaptureWidget.value = false;
        return;
      }
      final String path = (await getApplicationDocumentsDirectory()).path;
      File newImage =
          await File('$path/job_${job.id}.png').writeAsBytes(bytes!);
      Share.shareXFiles([XFile(newImage.path)],
          subject: "Hey wanna apply to this Job?",
          text:
              '''
Click on this link to view this Job
http://joinmyship.com/job/?job_id=${job.id}
''');
    } catch (e) {
      Share.share(
          '''
Click on this link to view this Job
http://joinmyship.com/job/?job_id=${job.id}
''');
    }
    buildCaptureWidget.value = false;
    print(bytes);
  }
}

class CompanyDetailArguments {
  final CrewUser? employer;
  const CompanyDetailArguments({this.employer});
}

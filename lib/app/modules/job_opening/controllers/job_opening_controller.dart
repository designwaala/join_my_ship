import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/application_model.dart';
import 'package:join_my_ship/app/data/models/boosting_model.dart';
import 'package:join_my_ship/app/data/models/coc_model.dart';
import 'package:join_my_ship/app/data/models/cop_model.dart';
import 'package:join_my_ship/app/data/models/crew_user_model.dart';
import 'package:join_my_ship/app/data/models/job_model.dart';
import 'package:join_my_ship/app/data/models/ranks_model.dart';
import 'package:join_my_ship/app/data/models/subscription_model.dart';
import 'package:join_my_ship/app/data/models/vessel_list_model.dart';
import 'package:join_my_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_my_ship/app/data/providers/application_provider.dart';
import 'package:join_my_ship/app/data/providers/boosting_provider.dart';
import 'package:join_my_ship/app/data/providers/coc_provider.dart';
import 'package:join_my_ship/app/data/providers/cop_provider.dart';
import 'package:join_my_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_my_ship/app/data/providers/flag_provider.dart';
import 'package:join_my_ship/app/data/providers/follow_provider.dart';
import 'package:join_my_ship/app/data/providers/highlight_provider.dart';
import 'package:join_my_ship/app/data/providers/job_provider.dart';
import 'package:join_my_ship/app/data/providers/liked_post_provider.dart';
import 'package:join_my_ship/app/data/providers/ranks_provider.dart';
import 'package:join_my_ship/app/data/providers/subscription_provider.dart';
import 'package:join_my_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_my_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_my_ship/app/modules/success/controllers/success_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/utils/get_job_share_link.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:collection/collection.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

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

  RxnInt jobIdBeingDeleted = RxnInt();

  WidgetsToImageController widgetsToImageController =
      WidgetsToImageController();
  Uint8List? bytes;
  RxBool buildCaptureWidget = false.obs;
  RxBool isSharing = false.obs;
  RxBool isHighlighting = false.obs;
  RxnInt highlightingJob = RxnInt();

  List<Subscription>? subscriptions;
  RxBool isLoadingSubscriptions = false.obs;
  Rxn<Subscription> selectedSubscription = Rxn();
  RxBool isBoosting = false.obs;
  BoostingResponse? boostingResponse;

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
    await loadJobOpenings();
    await Future.wait([
      loadVesselTypes(),
      loadRanks(),
      loadCOC(),
      loadCOP(),
      loadWatchKeeping(),
      getSubscriptions(),
      _getFlags(),
      UserStates.instance.crewUser?.userTypeKey == 2
          ? getJobApplications()
          : Future.value(null)
    ]);
    isLoading.value = false;
  }

  Future<void> _getFlags() async {
    UserStates.instance.flags ??= await getIt<FlagProvider>().getFlags();
  }

  Future<void> likeJob() async {
    if (jobOpening.value?.id == null) {
      return;
    }
    likingJob.value = true;
    final response =
        await getIt<LikedPostProvider>().likePost(jobOpening.value?.id);
    likingJob.value = false;
    if (response.statusCode == 201) {
      jobOpening.value?.jobLikeCount =
          (jobOpening.value?.jobLikeCount ?? 0) + 1;
      jobOpening.value?.isJobLiked = true;
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
    UserStates.instance.vessels = vesselList;
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

  Future<void> deleteJobPost() async {
    if (jobOpening.value?.id == null) {
      return;
    }
    jobIdBeingDeleted.value = jobOpening.value?.id;
    int? statusCode =
        await getIt<JobProvider>().deleteJob(jobOpening.value!.id!);
    if (statusCode == 204) {
      Get.back();
    }
    jobIdBeingDeleted.value = null;
  }

  Future<void> captureWidget() async {
    if (Platform.isIOS) {
      Share.share('''
        Click on this link to view this Job
        ${getJobShareLink(jobOpening.value?.id)}
        ''', 
      subject: "Hey wanna apply to this Job?");
      return ;
    }
    buildCaptureWidget.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      bytes = await widgetsToImageController.capture();
      if (bytes == null) {
        Share.share('''
Click on this link to view this Job
${getJobShareLink(jobOpening.value?.id)}
''');
        buildCaptureWidget.value = false;
        return;
      }
      final String path = (await getApplicationDocumentsDirectory()).path;
      File newImage = await File('$path/job_${jobOpening.value?.id}.png')
          .writeAsBytes(bytes!);
      Share.shareXFiles([XFile(newImage.path)],
          subject: "Hey wanna apply to this Job?",
          text: '''
Click on this link to view this Job
${getJobShareLink(jobOpening.value?.id)}
''');
    } catch (e) {
      Share.share('''
Click on this link to view this Job
${getJobShareLink(jobOpening.value?.id)}
''');
    }
    buildCaptureWidget.value = false;
    print(bytes);
  }

  Future<void> highlightJob(int jobId, int subscriptionId) async {
    highlightingJob.value = jobId;
    final response = await getIt<HighlightProvider>()
        .jobHighlight(jobId: jobId, subscriptionId: subscriptionId);
    highlightingJob.value = null;
    if (response.userHighlight != null) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: alertDialogShape,
              titlePadding: EdgeInsets.zero,
              title: SizedBox(
                height: 180,
                width: 180,
                child: Lottie.asset('assets/animations/blue_tick.json',
                    repeat: true),
              ),
              contentPadding: const EdgeInsets.only(bottom: 16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Highlighted Successfully",
                      style: Get.textTheme.bodyMedium?.copyWith(
                          color: Get.theme.primaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700)),
                  16.verticalSpace,
                  FilledButton(onPressed: Get.back, child: const Text("Close"))
                ],
              ),
            );
          });
    }
  }

  Future<void> getSubscriptions() async {
    isLoadingSubscriptions.value = true;
    subscriptions = UserStates.instance.subscription ??
        await getIt<SubscriptionProvider>().getSubscriptions();
    isLoadingSubscriptions.value = false;
  }

  Future<void> boostJob(int jobId) async {
    getSubscriptions();
    showDialog(
        context: Get.context!,
        builder: (context) {
          return Obx(() {
            return AlertDialog(
              shape: alertDialogShape,
              title: const Text("Choose the Plan"),
              content: isLoadingSubscriptions.value
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: subscriptions
                              ?.where((e) =>
                                  e.isTypeKey?.type == PlanType.employerBoost)
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        selectedSubscription.value = e;
                                      },
                                      child: Card(
                                        color: selectedSubscription.value?.id ==
                                                e.id
                                            ? Get.theme.primaryColor
                                            : null,
                                        shape: RoundedRectangleBorder(
                                            side: selectedSubscription
                                                        .value?.id ==
                                                    e.id
                                                ? BorderSide(
                                                    color:
                                                        Get.theme.primaryColor)
                                                : BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  4.horizontalSpace,
                                                  Text(
                                                      e.planName?.planName ??
                                                          "",
                                                      style: Get
                                                          .textTheme.titleSmall
                                                          ?.copyWith(
                                                              color: selectedSubscription
                                                                          .value
                                                                          ?.id ==
                                                                      e.id
                                                                  ? Colors.white
                                                                  : null)),
                                                ],
                                              ),
                                              8.verticalSpace,
                                              Text(
                                                  "Days Active: ${e.daysActive}",
                                                  style: Get
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          color:
                                                              selectedSubscription
                                                                          .value
                                                                          ?.id ==
                                                                      e.id
                                                                  ? Colors.white
                                                                  : null)),
                                              Text(
                                                  "Credits Required: ${e.points}",
                                                  style: Get
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          color:
                                                              selectedSubscription
                                                                          .value
                                                                          ?.id ==
                                                                      e.id
                                                                  ? Colors.white
                                                                  : null))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList() ??
                          []),
              actions: [
                TextButton(onPressed: Get.back, child: Text("Close")),
                isBoosting.value
                    ? const CircularProgressIndicator()
                    : FilledButton(
                        onPressed: selectedSubscription.value == null
                            ? null
                            : () async {
                                if (selectedSubscription.value?.planName?.id ==
                                    null) {
                                  return;
                                }
                                isBoosting.value = true;
                                boostingResponse =
                                    await getIt<BoostingProvider>().boostJob(
                                        subscriptionId: selectedSubscription
                                            .value!.planName!.id!,
                                        postBoost: jobId);
                                if (boostingResponse?.postBoost != null) {
                                  fToast.showToast(
                                      child: successToast(
                                          "Job Post Boosted Successfully"));
                                  Get.back();
                                }
                                isBoosting.value = false;
                              },
                        child: const Text("Boost"))
              ],
              actionsPadding: EdgeInsets.only(right: 32, bottom: 16),
            );
          });
        });
  }
}

class JobOpeningArguments {
  final int? jobId;
  const JobOpeningArguments({this.jobId});
}

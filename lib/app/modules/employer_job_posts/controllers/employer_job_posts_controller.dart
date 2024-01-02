import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_mp_ship/app/data/models/boosting_model.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/subscription_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/boosting_provider.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/flag_provider.dart';
import 'package:join_mp_ship/app/data/providers/highlight_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/subscription_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:collection/collection.dart';

class EmployerJobPostsController extends GetxController {
  RxList<Job> jobPosts = RxList.empty();
  Rxn<CrewUser> currentEmployerUser = Rxn();
/*   RxMap<int, String> vesselTypes = RxMap();
  RxMap<int, String> rankTypes = RxMap();
  RxMap<int, String> cocTypes = RxMap();
  RxMap<int, String> copTypes = RxMap();
  RxMap<int, String> watchKeepingTypes = RxMap(); */
  // VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();

  RxBool isLoading = false.obs;

  RxnInt jobIdBeingDeleted = RxnInt();

  WidgetsToImageController widgetsToImageController =
      WidgetsToImageController();
  Uint8List? bytes;
  RxBool buildCaptureWidget = false.obs;
  RxBool isSharing = false.obs;
  Job? jobToBuild;
  RxnInt highlightingJob = RxnInt();

  List<Subscription>? subscriptions;
  RxBool isLoadingSubscriptions = false.obs;
  Rxn<Subscription> selectedSubscription = Rxn();
  RxBool isBoosting = false.obs;
  BoostingResponse? boostingResponse;

  final fToast = FToast();
  final parentKey = GlobalKey();

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
      loadJobPosts(),
      loadVesselTypes(),
      loadRanks(),
      loadCOC(),
      loadCOP(),
      loadWatchKeeping(),
      _loadFlags()
    ]);
    isLoading.value = false;
  }

  Future<void> _loadFlags() async {
    UserStates.instance.flags ??= await getIt<FlagProvider>().getFlags();
  }

  Future<void> loadJobPosts() async {
    jobPosts.value = (await getIt<JobProvider>()
            .getJobList(employerId: PreferencesHelper.instance.userId ?? -1)) ??
        [];
  }

  Future<void> loadVesselTypes() async {
    UserStates.instance.vessels ??=
        await getIt<VesselListProvider>().getVesselList();
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

  Future<void> deleteJobPost(int jobId) async {
    jobIdBeingDeleted.value = jobId;
    int? statusCode = await getIt<JobProvider>().deleteJob(jobId);
    if (statusCode == 204) {
      jobPosts.removeWhere((jobPost) => jobPost.id == jobId);
    }
    jobIdBeingDeleted.value = null;
  }

  Future<void> captureWidget(Job job) async {
    jobToBuild = job;
    buildCaptureWidget.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      bytes = await widgetsToImageController.capture();
      if (bytes == null) {
        Share.share('''
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
          text: '''
Click on this link to view this Job
http://joinmyship.com/job/?job_id=${job.id}
''');
    } catch (e) {
      Share.share('''
Click on this link to view this Job
http://joinmyship.com/job/?job_id=${job.id}
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
                              ?.where(
                                  (e) => e.isTypeKey?.type == PlanType.boosting)
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
                                }
                                isBoosting.value = false;
                                Get.back();
                              },
                        child: const Text("Boost"))
              ],
              actionsPadding: EdgeInsets.only(right: 32, bottom: 16),
            );
          });
        });
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }
}

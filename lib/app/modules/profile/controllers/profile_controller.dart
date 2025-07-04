import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/boosting_model.dart';
import 'package:join_my_ship/app/data/models/crew_user_model.dart';
import 'package:join_my_ship/app/data/models/highlight_model.dart';
import 'package:join_my_ship/app/data/models/subscription_model.dart';
import 'package:join_my_ship/app/data/providers/boosting_provider.dart';
import 'package:join_my_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_my_ship/app/data/providers/current_job_post_provider.dart';
import 'package:join_my_ship/app/data/providers/highlight_provider.dart';
import 'package:join_my_ship/app/data/providers/subscription_provider.dart';
import 'package:join_my_ship/app/data/providers/user_details_provider.dart';
import 'package:join_my_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';

class ProfileController extends GetxController
    with PickImage, GetSingleTickerProviderStateMixin {
  RxBool isLoading = false.obs;
  Rxn<CrewUser> crewUser = Rxn();

  final parentKey = GlobalKey();
  FToast fToast = FToast();
  Rxn<File> pickedResume = Rxn();

  String get rank =>
      UserStates.instance.ranks
          ?.firstWhereOrNull(
              (rank) => rank.id == (crewUser.value?.rankId ?? -1))
          ?.name ??
      "";
  String? version = packageInfo?.version;
  String? buildNumber = packageInfo?.buildNumber;
  RxBool isHighlighting = false.obs;
  RxBool isBoosting = false.obs;
  Highlight? highlight;
  BoostingResponse? boosting;

  List<Subscription>? subscriptions;
  RxBool isLoadingSubscriptions = false.obs;
  Rxn<Subscription> selectedSubscription = Rxn();

  RxBool isStartingJobPostPlan = false.obs;
  RxBool isDeletingAccount = false.obs;

  RxBool isFreeTrialActivated = true.obs;

  final gradientColors = [
    const Color(0xFF371C57),
    const Color(0xFFB92BD8),
    const Color(0xFF5F25E1),
    const Color(0xFF2D22DD)
  ];

  late AnimationController animationController;
  late Animation<Color?> colorTween;
  final double lastValue = 0;

  // RxBool isFreeTrialAvailed = true.obs;

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  instantiate() async {
    isLoading.value = true;
    crewUser.value = UserStates.instance.crewUser ??
        (await getIt<CrewUserProvider>().getCrewUser());
    isLoading.value = false;

    if (crewUser.value?.userTypeKey == 5) {
      isFreeTrialActivated.value =
          (await getIt<UserDetailsProvider>().checkIfFreeTrialIsAvailed()) ?? true;
      animationController = AnimationController(
          vsync: this, duration: const Duration(seconds: 5));

      colorTween = ColorTween(begin: const Color(0xFF2D22DD), end: const Color(0xFFB92BD8))
          .animate(CurvedAnimation(
              parent: animationController, curve: Curves.easeOutSine))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController.reverse();
          }
          if (status == AnimationStatus.dismissed) {
            animationController.forward();
          }
        });
      animationController.forward();
    }
  }

  Future<void> startJobPostPlan() async {
    isStartingJobPostPlan.value = true;
    final response = await getIt<CurrentJobPostProvider>().startFreeTrial();
    if (response?.id != null) {
      fToast.showToast(child: successToast("Trial Started Successfully"));
      PreferencesHelper.instance.setFreeTrialAvailed(true);
      isFreeTrialActivated.value = true;
      Get.back();
    }
    isStartingJobPostPlan.value = false;
  }

  updateImage() async {
    if (crewUser.value?.id == null) {
      return;
    }
    await pickSource();
    if (pickedImage.value == null) {
      return;
    }
    bool? confirm = await confirmUpdate();
    if (confirm != true) {
      pickedImage.value = null;
      return;
    }
    isLoading.value = true;
    await getIt<CrewUserProvider>().updateCrewUser(
      crewId: crewUser.value!.id!,
      profilePicPath: pickedImage.value?.path,
    );
    crewUser.value = await getIt<CrewUserProvider>().getCrewUser();
    pickedImage.value = null;
    isLoading.value = false;
  }

  updateResume() async {
    if (crewUser.value?.id == null) {
      return;
    }
    bool? confirm = await showDialog<bool>(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            shape: alertDialogShape,
            title:
                const Text("Are you sure you want to update to this Resume?"),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    Get.back(result: true);
                  },
                  child: const Text("Yes")),
              8.horizontalSpace,
              OutlinedButton(
                  onPressed: () {
                    pickedImage.value = null;
                    Get.back(result: false);
                  },
                  child: const Text("No")),
              8.horizontalSpace,
            ],
          );
        });

    if (confirm != true) {
      pickedResume.value = null;
      return;
    }
    isLoading.value = true;
    await getIt<CrewUserProvider>().updateCrewUser(
        crewId: crewUser.value!.id!, resumePath: pickedResume.value?.path);
    crewUser.value = await getIt<CrewUserProvider>().getCrewUser();
    pickedResume.value = null;
    isLoading.value = false;
  }

  Future<void> getSubscriptions() async {
    isLoadingSubscriptions.value = true;
    subscriptions = UserStates.instance.subscription ??
        await getIt<SubscriptionProvider>().getSubscriptions();
    isLoadingSubscriptions.value = false;
  }

  Future<void> boostCrew() async {
    boosting = null;
    getSubscriptions();
    await showDialog(
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
                  : SizedBox(
                    width: Get.width * 0.9,
                     height: 500,
                    child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: subscriptions
                                ?.where((e) =>
                                    e.isTypeKey?.type == PlanType.crewBoost)
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
                  ),
              actions: [
                TextButton(onPressed: Get.back, child: const Text("Close")),
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
                                boosting = await getIt<BoostingProvider>()
                                    .boostCrewProfile(
                                        subscriptionId: selectedSubscription
                                            .value!.planName!.id!);
                                isBoosting.value = false;
                                if (boosting?.daysActive != null) {
                                  Get.back();
                                }
                              },
                        child: const Text("Boost"))
              ],
              actionsPadding: const EdgeInsets.only(right: 32, bottom: 16),
            );
          });
        });
    if (boosting?.daysActive != null) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: alertDialogShape,
              title: const Text("Your Profile was successfully Boosted"),
              content: Text("Remaining Days ${boosting?.daysActive}."),
              actions: [
                FilledButton(onPressed: Get.back, child: const Text("DONE"))
              ],
              actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
            );
          });
    }
/*     else {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: alertDialogShape,
              title: Text("Some Error Occurred."),
              contentPadding: EdgeInsets.zero,
              actions: [
                TextButton(
                    onPressed: Get.back, child: const Text("No, Thanks")),
                4.horizontalSpace,
                FilledButton(
                    onPressed: () {
                      Get.toNamed(Routes.SUBSCRIPTIONS);
                    },
                    child: const Text("Buy Credits"))
              ],
              actionsPadding: EdgeInsets.only(right: 16, bottom: 16),
            );
          });
    } */
  }

  Future<void> highlightCrew() async {
    highlight = null;
    getSubscriptions();
    await showDialog(
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
                  : SizedBox(
                      width: Get.width * 0.9,
                      height: 500,
                      child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: subscriptions
                                  ?.where((e) =>
                                      e.isTypeKey?.type ==
                                      PlanType.crewHighlight)
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            selectedSubscription.value = e;
                                          },
                                          child: Card(
                                            color: selectedSubscription
                                                        .value?.id ==
                                                    e.id
                                                ? Get.theme.primaryColor
                                                : null,
                                            shape: RoundedRectangleBorder(
                                                side: selectedSubscription
                                                            .value?.id ==
                                                        e.id
                                                    ? BorderSide(
                                                        color: Get
                                                            .theme.primaryColor)
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
                                                          e.planName
                                                                  ?.planName ??
                                                              "",
                                                          style: Get.textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                  color: selectedSubscription
                                                                              .value
                                                                              ?.id ==
                                                                          e.id
                                                                      ? Colors
                                                                          .white
                                                                      : null)),
                                                    ],
                                                  ),
                                                  8.verticalSpace,
                                                  Text(
                                                      "Days Active: ${e.daysActive}",
                                                      style: Get
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                              color: selectedSubscription
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
                                                              color: selectedSubscription
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
                    ),
              actions: [
                TextButton(onPressed: Get.back, child: const Text("Close")),
                isHighlighting.value
                    ? const CircularProgressIndicator()
                    : FilledButton(
                        onPressed: selectedSubscription.value == null
                            ? null
                            : () async {
                                if (selectedSubscription.value?.planName?.id ==
                                    null) {
                                  return;
                                }
                                isHighlighting.value = true;
                                highlight = await getIt<HighlightProvider>()
                                    .crewHighlight(selectedSubscription
                                        .value!.planName!.id!);
                                isHighlighting.value = false;
                                if (highlight?.daysActive != null) {
                                  Get.back();
                                }
                              },
                        child: const Text("Highlight"))
              ],
              actionsPadding: const EdgeInsets.only(right: 32, bottom: 16),
            );
          });
        });
    if (highlight?.daysActive != null) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: alertDialogShape,
              title: const Text("Your Profile was successfully Highlighted"),
              content: Text("Remaining Days ${highlight?.daysActive}."),
              actions: [
                FilledButton(onPressed: Get.back, child: const Text("DONE"))
              ],
              actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
            );
          });
    }
    /* else if (highlight?.success == false && highlight?.message != null) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: alertDialogShape,
              title: Text(highlight?.message ?? ""),
              contentPadding: EdgeInsets.zero,
              actions: [
                TextButton(
                    onPressed: Get.back, child: const Text("No, Thanks")),
                4.horizontalSpace,
                FilledButton(
                    onPressed: () {
                      Get.toNamed(Routes.SUBSCRIPTIONS);
                    },
                    child: const Text("Buy Credits"))
              ],
              actionsPadding: EdgeInsets.only(right: 16, bottom: 16),
            );
          });
    } */
  }

  int taps = 0;
  crash() {
    if (RemoteConfigUtils.instance.intentionalCrash != true) {
      return;
    }
    taps++;
    if (taps == 5) {
      fToast.showToast(child: successToast("Going to crash"));
      FirebaseCrashlytics.instance.crash();
    }
  }

  Future<void> deleteAccount() async {
    if (crewUser.value?.id == null) {
      return;
    }
    isDeletingAccount.value = true;
    final response =
        await getIt<CrewUserProvider>().deleteUser(crewUser.value!.id!);
    if (response == 204) {
      Get.offAllNamed(Routes.SPLASH);
    }
    isDeletingAccount.value = false;
  }

  @override
  void onClose() {
    if (crewUser.value?.userTypeKey == 5) {
      animationController.dispose();
    }
    super.onClose();
  }
}

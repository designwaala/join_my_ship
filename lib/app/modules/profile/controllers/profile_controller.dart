import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/highlight_model.dart';
import 'package:join_mp_ship/app/data/models/subscription_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/highlight_provider.dart';
import 'package:join_mp_ship/app/data/providers/subscription_provider.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class ProfileController extends GetxController with PickImage {
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
  Highlight? highlight;
  List<Subscription>? subscriptions;
  RxBool isLoadingSubscriptions = false.obs;
  Rxn<Subscription> selectedSubscription = Rxn();

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
            title: Text("Are you sure you want to update to this Resume?"),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    Get.back(result: true);
                  },
                  child: Text("Yes")),
              8.horizontalSpace,
              OutlinedButton(
                  onPressed: () {
                    pickedImage.value = null;
                    Get.back(result: false);
                  },
                  child: Text("No")),
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

  Future<void> highlightCrew() async {
    getSubscriptions();
    await showDialog(
        context: Get.context!,
        builder: (context) {
          return Obx(() {
            return AlertDialog(
              title: Text("Choose the Plan"),
              content: isLoadingSubscriptions.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: subscriptions
                              ?.where((e) =>
                                  e.isTypeKey?.type ==
                                  PlanType.highlightProfile)
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        selectedSubscription.value = e;
                                      },
                                      child: Card(
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
                                                  Icon(
                                                      selectedSubscription
                                                                  .value?.id ==
                                                              e.id
                                                          ? Icons.check_box
                                                          : Icons
                                                              .check_box_outline_blank,
                                                      color: Get
                                                          .theme.primaryColor),
                                                  4.horizontalSpace,
                                                  Text(
                                                      e.planName?.planName ??
                                                          "",
                                                      style: Get.textTheme
                                                          .titleSmall),
                                                ],
                                              ),
                                              8.verticalSpace,
                                              Text(
                                                  "Days Active: ${e.daysActive}"),
                                              Text(
                                                  "Points Required: ${e.points}")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList() ??
                          []),
              actions: [
                isHighlighting.value
                    ? CircularProgressIndicator()
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
                                Get.back();
                              },
                        child: Text("Highlight"))
              ],
            );
          });
        });
    if (highlight != null) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text("Your Profile was successfully Highlighted"),
              content: Text("Remaining Days ${highlight?.daysActive}."),
              actions: [FilledButton(onPressed: Get.back, child: Text("OK"))],
            );
          });
    }
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/vessel_list_model.dart';
import 'package:join_my_ship/app/modules/job_opening/controllers/job_opening_controller.dart';
import 'package:join_my_ship/app/modules/subscriptions/controllers/subscriptions_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/utils/extensions/date_time.dart';

class ActivePlansView extends GetView<SubscriptionsController> {
  const ActivePlansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoadingPurchases.value
          ? const CircularProgressIndicator()
          : Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.getPurchases();
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    if (UserStates.instance.crewUser?.userTypeKey != 2)
                      //EMPLOYER
                      ...[
                      InkWell(
                        onTap: () {
                          controller.showResumePacksPurchases.value =
                              !controller.showResumePacksPurchases.value;
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Packs Purchases",
                                style: Get.textTheme.titleLarge),
                            Icon(
                                controller.showResumePacksPurchases.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 32)
                          ],
                        ),
                      ),
                      16.verticalSpace,
                      AnimatedCrossFade(
                          firstChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.currentPackPurchases
                                      .map((resumePack) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      8.verticalSpace,
                                                      Text(
                                                          UserStates.instance
                                                                  .resumePacks
                                                                  ?.firstWhereOrNull((pack) =>
                                                                      pack.id ==
                                                                      resumePack
                                                                          .purchasePack)
                                                                  ?.name ??
                                                              "",
                                                          style: Get.textTheme
                                                              .titleMedium),
                                                      4.verticalSpace,
                                                    ],
                                                  ),
                                                )),
                                          ))
                                      .toList() ??
                                  []),
                          secondChild: const SizedBox(),
                          crossFadeState:
                              controller.showResumePacksPurchases.value
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300)),
                      16.verticalSpace,
                      InkWell(
                        onTap: () {
                          controller.showResumeTopUpPurchases.value =
                              !controller.showResumeTopUpPurchases.value;
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Top Up Purchases",
                                style: Get.textTheme.titleLarge),
                            Icon(
                                controller.showResumeTopUpPurchases.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 32)
                          ],
                        ),
                      ),
                      16.verticalSpace,
                      AnimatedCrossFade(
                          firstChild: Column(
                              children: controller.currentTopUpPurchases
                                  .map((resumeTopUp) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: SizedBox(
                                              width: double.maxFinite,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    8.verticalSpace,
                                                    Text(
                                                        UserStates.instance
                                                                .resumeTopUps
                                                                ?.firstWhereOrNull(
                                                                    (topUp) =>
                                                                        topUp
                                                                            .id ==
                                                                        resumeTopUp
                                                                            .purchaseTopUp)
                                                                ?.name ??
                                                            "",
                                                        style: Get.textTheme
                                                            .titleMedium),
                                                    4.verticalSpace,
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ))
                                  .toList()),
                          secondChild: const SizedBox(),
                          crossFadeState:
                              controller.showResumeTopUpPurchases.value
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300)),
                      16.verticalSpace,
                      InkWell(
                        onTap: () {
                          controller.showBoostings.value =
                              !controller.showBoostings.value;
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Boostings", style: Get.textTheme.titleLarge),
                            Icon(
                                controller.showBoostings.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 32)
                          ],
                        ),
                      ),
                      16.verticalSpace,
                      AnimatedCrossFade(
                          firstChild: Column(
                              children: controller.currentEmployerBoostings
                                  .map((boosting) => InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.JOB_OPENING,
                                              arguments: JobOpeningArguments(
                                                  jobId:
                                                      boosting.postBoost?.id));
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: SizedBox(
                                            width: double.maxFinite,
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Vessel Type: ",
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.copyWith(
                                                                      color: Colors
                                                                          .blue),
                                                            ),
                                                            8.horizontalSpace,
                                                            Text(UserStates
                                                                    .instance
                                                                    .vessels
                                                                    ?.vessels
                                                                    ?.expand<
                                                                            SubVessel>(
                                                                        (e) =>
                                                                            e.subVessels ??
                                                                            [])
                                                                    .firstWhereOrNull((vessel) =>
                                                                        vessel
                                                                            .id ==
                                                                        boosting
                                                                            .postBoost
                                                                            ?.vesselId)
                                                                    ?.name ??
                                                                "")
                                                          ]),
                                                      4.verticalSpace,
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "GRT: ",
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.copyWith(
                                                                      color: Colors
                                                                          .blue),
                                                            ),
                                                            8.horizontalSpace,
                                                            Text(boosting
                                                                    .postBoost
                                                                    ?.gRT ??
                                                                "")
                                                          ]),
                                                      Text(
                                                          "Days Active: ${boosting.daysActive}",
                                                          style: Get.textTheme
                                                              .titleMedium),
                                                      4.verticalSpace,
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ))
                                  .toList()),
                          secondChild: const SizedBox(),
                          crossFadeState: controller.showBoostings.value
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300)),
                      if (UserStates.instance.crewUser?.userTypeKey == 5) ...[
                        16.verticalSpace,
                        InkWell(
                          onTap: () {
                            controller.showJobPostPurchases.value =
                                !controller.showJobPostPurchases.value;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Job Post Plan",
                                  style: Get.textTheme.titleLarge),
                              Icon(
                                  controller.showJobPostPurchases.value
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 32)
                            ],
                          ),
                        ),
                        16.verticalSpace,
                        AnimatedCrossFade(
                            firstChild: Column(
                                children: controller.currentJobPostPacks
                                        ?.map((boosting) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: SizedBox(
                                                width: double.maxFinite,
                                                child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Purchased On: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge
                                                                      ?.copyWith(
                                                                          color:
                                                                              Colors.blue),
                                                                ),
                                                                8.horizontalSpace,
                                                                /* Text(UserStates
                                                                .instance
                                                                .vessels
                                                                ?.vessels
                                                                ?.expand<
                                                                        SubVessel>(
                                                                    (e) =>
                                                                        e.subVessels ??
                                                                        [])
                                                                .firstWhereOrNull((vessel) =>
                                                                    vessel
                                                                        .id ==
                                                                    boosting
                                                                        .postBoost
                                                                        ?.vesselId)
                                                                ?.name ??
                                                            "") */
                                                              ]),
                                                          4.verticalSpace,
                                                          Text(
                                                              "${DateTime.tryParse(boosting.createdAt ?? "")?.getCompactDisplayDate()}",
                                                              style: Get
                                                                  .textTheme
                                                                  .titleMedium),
                                                          4.verticalSpace,
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ))
                                        .toList() ??
                                    []),
                            secondChild: const SizedBox(),
                            crossFadeState:
                                controller.showJobPostPurchases.value
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300)),
                        16.verticalSpace,
                        InkWell(
                          onTap: () {
                            controller.showJobPostTopUpPurchases.value =
                                !controller.showJobPostTopUpPurchases.value;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Job Post Top Up",
                                  style: Get.textTheme.titleLarge),
                              Icon(
                                  controller.showJobPostTopUpPurchases.value
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 32)
                            ],
                          ),
                        ),
                        16.verticalSpace,
                        AnimatedCrossFade(
                            firstChild: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Posts Left: ",
                                                  style: Get.textTheme.bodyLarge
                                                      ?.copyWith(
                                                          color: Colors.blue),
                                                ),
                                                8.horizontalSpace,
                                              ]),
                                          4.verticalSpace,
                                          Text(
                                              "${controller.currentJobPostTopUps?.postsLeft}",
                                              style: Get.textTheme.titleMedium),
                                          4.verticalSpace,
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            secondChild: const SizedBox(),
                            crossFadeState:
                                controller.showJobPostTopUpPurchases.value
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300)),
                      ]
                    ] else
                      //CREW
                      ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Boostings", style: Get.textTheme.titleLarge),
                          InkWell(
                            onTap: () {
                              controller.showBoostings.value =
                                  !controller.showBoostings.value;
                            },
                            child: Icon(
                                controller.showBoostings.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 32),
                          )
                        ],
                      ),
                      16.verticalSpace,
                      AnimatedCrossFade(
                          firstChild: controller.currentCrewBoostings.value ==
                                  null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  8.verticalSpace,
                                                  Text(
                                                      "Days Active: ${controller.currentCrewBoostings.value?.daysActive}",
                                                      style: Get.textTheme
                                                          .titleMedium),
                                                  4.verticalSpace,
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                          secondChild: const SizedBox(),
                          crossFadeState: controller.showBoostings.value
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300)),
                      16.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Highlights", style: Get.textTheme.titleLarge),
                          InkWell(
                            onTap: () {
                              controller.showHighlights.value =
                                  !controller.showHighlights.value;
                            },
                            child: Icon(
                                controller.showHighlights.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 32),
                          )
                        ],
                      ),
                      16.verticalSpace,
                      AnimatedCrossFade(
                          firstChild: Column(
                              children: controller.currentCrewHighlights
                                  .map((highlight) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        8.verticalSpace,
                                                        Text(
                                                            "Days Active: ${highlight.daysActive}",
                                                            style: Get.textTheme
                                                                .titleMedium),
                                                        4.verticalSpace,
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList()),
                          secondChild: const SizedBox(),
                          crossFadeState: controller.showHighlights.value
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300)),
                    ]
                  ],
                ),
              ),
            );
    });
  }
}

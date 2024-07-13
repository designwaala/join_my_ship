import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/subscriptions/controllers/subscriptions_controller.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:collection/collection.dart';

class BuyPlansView extends GetView<SubscriptionsController> {
  const BuyPlansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoadingPlans.value
          ? const CircularProgressIndicator()
          : Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Resume Download Packs",
                          style: Get.textTheme.titleLarge),
                      InkWell(
                        onTap: () {
                          controller.showResumePacks.value =
                              !controller.showResumePacks.value;
                        },
                        child: Icon(
                            controller.showResumePacks.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 32),
                      )
                    ],
                  ),
                  16.verticalSpace,
                  AnimatedCrossFade(
                      firstChild: Column(
                          children: UserStates.instance.resumePacks
                                  ?.map((resumePack) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18,
                                                  top: 12,
                                                  bottom: 12,
                                                  right: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  8.verticalSpace,
                                                  Text(
                                                      resumePack.name
                                                              ?.split(" - ")
                                                              .firstOrNull ??
                                                          "",
                                                      style: Get
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Get
                                                                  .theme
                                                                  .colorScheme
                                                                  .tertiary)),
                                                  Divider(
                                                      color:
                                                          Colors.grey.shade600),
                                                  8.verticalSpace,
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/coins.svg",
                                                        height: 32,
                                                        width: 32,
                                                      ),
                                                      4.horizontalSpace,
                                                      Text(
                                                          resumePack.name
                                                                  ?.split(" - ")
                                                                  .lastOrNull ??
                                                              "",
                                                          style: Get.textTheme
                                                              .titleLarge),
                                                    ],
                                                  ),
                                                  8.verticalSpace,
                                                  Text(
                                                      "Daily Downloads Limit: ${resumePack.dailyLimit ?? ""}"),
                                                  Text(
                                                      "Validity: ${resumePack.durationDays} days"),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: controller.buyingPlan
                                                                .value ==
                                                            resumePack.id
                                                        ? const SizedBox(
                                                            height: 16,
                                                            width: 16,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : FilledButton(
                                                            onPressed:
                                                                resumePack.id ==
                                                                        null
                                                                    ? null
                                                                    : () {
                                                                        controller
                                                                            .buyPlan(resumePack.id!);
                                                                      },
                                                            child: const Text(
                                                                "Buy Now")),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ))
                                  .toList() ??
                              []),
                      secondChild: const SizedBox(),
                      crossFadeState: controller.showResumePacks.value
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300)),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Resume Top Ups", style: Get.textTheme.titleLarge),
                      InkWell(
                        onTap: () {
                          controller.showResumeTopUpPacks.value =
                              !controller.showResumeTopUpPacks.value;
                        },
                        child: Icon(
                            controller.showResumeTopUpPacks.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 32),
                      )
                    ],
                  ),
                  16.verticalSpace,
                  AnimatedCrossFade(
                      firstChild: Column(
                          children: UserStates.instance.resumeTopUps
                                  ?.map((resumeTopUp) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18,
                                                  top: 12,
                                                  bottom: 12,
                                                  right: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  8.verticalSpace,
                                                  Text(
                                                      resumeTopUp.name
                                                              ?.split(" - ")
                                                              .firstOrNull ??
                                                          "",
                                                      style: Get
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Get
                                                                  .theme
                                                                  .colorScheme
                                                                  .tertiary)),
                                                  Divider(
                                                      color:
                                                          Colors.grey.shade600),
                                                  8.verticalSpace,
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/coins.svg",
                                                        height: 32,
                                                        width: 32,
                                                      ),
                                                      4.horizontalSpace,
                                                      Text(
                                                          resumeTopUp.name
                                                                  ?.split(" - ")
                                                                  .lastOrNull ??
                                                              "",
                                                          style: Get.textTheme
                                                              .titleLarge),
                                                    ],
                                                  ),
                                                  8.verticalSpace,
                                                  Text(
                                                      "Daily Downloads Limit: ${resumeTopUp.durationDays ?? ""} days"),
                                                  Text(
                                                      "Validity: ${resumeTopUp.durationDays} days"),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: controller
                                                                .toppingUpPlan
                                                                .value ==
                                                            resumeTopUp.id
                                                        ? const SizedBox(
                                                            height: 16,
                                                            width: 16,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : FilledButton(
                                                            onPressed:
                                                                resumeTopUp.id ==
                                                                        null
                                                                    ? null
                                                                    : () {
                                                                        controller
                                                                            .topUp(resumeTopUp.id!);
                                                                      },
                                                            child: const Text(
                                                                "Buy Now")),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ))
                                  .toList() ??
                              []),
                      secondChild: const SizedBox(),
                      crossFadeState: controller.showResumeTopUpPacks.value
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300)),
                  if (UserStates.instance.crewUser?.userTypeKey == 5) ...[
                    //Don't have GET API for Job Post, therefore values are hardcoded
                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Job Post Plan", style: Get.textTheme.titleLarge),
                        InkWell(
                          onTap: () {
                            controller.showJobPostPacks.value =
                                !controller.showJobPostPacks.value;
                          },
                          child: Icon(
                              controller.showResumeTopUpPacks.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 32),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    AnimatedCrossFade(
                        firstChild: Column(
                            children: controller.jobPostPacks
                                .mapIndexed((index, jobPostPack) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18,
                                                top: 12,
                                                bottom: 12,
                                                right: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                8.verticalSpace,
                                                Text(jobPostPack.name ?? "",
                                                    style: Get
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Get
                                                                .theme
                                                                .colorScheme
                                                                .tertiary)),
                                                Divider(
                                                    color:
                                                        Colors.grey.shade600),
                                                8.verticalSpace,
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/coins.svg",
                                                      height: 32,
                                                      width: 32,
                                                    ),
                                                    4.horizontalSpace,
                                                    Text(
                                                        "${double.tryParse(jobPostPack.price ?? "") ?? ""}",
                                                        style: Get.textTheme
                                                            .titleLarge),
                                                  ],
                                                ),
                                                8.verticalSpace,
                                                // const Text("Post 30 Jobs for a Month"),
                                                Text(
                                                      "Post ${jobPostPack.monthlyLimit ?? ""} New Jobs"),
                                                Text(
                                                    "Validity: ${jobPostPack.durationDays ?? ""} days"),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: controller
                                                          .jobPostPlanBeingBought
                                                          .value == jobPostPack.id
                                                      ? const SizedBox(
                                                          height: 16,
                                                          width: 16,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )
                                                      : FilledButton(
                                                          onPressed: controller
                                                                      .jobPostPlanBeingBought
                                                                      .value ==
                                                                  jobPostPack.id
                                                              ? null
                                                              : () {
                                                                  if (jobPostPack
                                                                          .id ==
                                                                      null) {
                                                                    return;
                                                                  }
                                                                  controller.buyJobPostPlan(
                                                                      jobPostPack
                                                                          .id!);
                                                                },
                                                          child: const Text(
                                                              "Buy Now")),
                                                )
                                              ],
                                            ),
                                          )),
                                    ))
                                .toList()),
                        secondChild: const SizedBox(),
                        crossFadeState: controller.showJobPostPacks.value
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300)),

                    //Don't have GET API for Post Plan Top, therefore hardcoding
                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Job Post Top Ups",
                            style: Get.textTheme.titleLarge),
                        InkWell(
                          onTap: () {
                            controller.showJobPostTopUpPacks.value =
                                !controller.showJobPostTopUpPacks.value;
                          },
                          child: Icon(
                              controller.showJobPostTopUpPacks.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 32),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    AnimatedCrossFade(
                        firstChild: Column(
                            children: RemoteConfigUtils
                                    .instance.jobPostTopUpPacks
                                    ?.mapIndexed(
                                      (index, jobPostTopUpPack) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18,
                                                  top: 12,
                                                  bottom: 12,
                                                  right: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  8.verticalSpace,
                                                  Text("Top-Up ${index + 1}",
                                                      style: Get
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Get
                                                                  .theme
                                                                  .colorScheme
                                                                  .tertiary)),
                                                  Divider(
                                                      color:
                                                          Colors.grey.shade600),
                                                  8.verticalSpace,
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/coins.svg",
                                                        height: 32,
                                                        width: 32,
                                                      ),
                                                      4.horizontalSpace,
                                                      Text(
                                                          ((controller.jobPostTopUpPack
                                                                              ?.points ??
                                                                          0) *
                                                                      (jobPostTopUpPack
                                                                              .postPurchased ??
                                                                          0))
                                                                  .toString() ??
                                                              ""
                                                          //We wont  get points used from remote config, rather calculate it based on API response
                                                          /* jobPostTopUpPack
                                                                  .pointsUsed
                                                                  ?.toString() ??
                                                              "" */
                                                          ,
                                                          style: Get.textTheme
                                                              .titleLarge),
                                                    ],
                                                  ),
                                                  8.verticalSpace,
                                                  Text(
                                                      "Post ${jobPostTopUpPack.postPurchased ?? ""} New Jobs"),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: controller
                                                                .jobPostTopUpPlan
                                                                .value ==
                                                            jobPostTopUpPack
                                                                .pointsUsed
                                                        ? const SizedBox(
                                                            height: 16,
                                                            width: 16,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : FilledButton(
                                                            onPressed: controller
                                                                        .jobPostTopUpPlan
                                                                        .value ==
                                                                    jobPostTopUpPack
                                                                        .pointsUsed
                                                                ? null
                                                                : () {
                                                                    controller.topUpJobPostPlan(
                                                                        topUpPack:
                                                                            jobPostTopUpPack);
                                                                  },
                                                            child: const Text(
                                                                "Buy Now")),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ),
                                    )
                                    .toList() ??
                                []),
                        secondChild: const SizedBox(),
                        crossFadeState: controller.showJobPostTopUpPacks.value
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300)),
                  ]
                ],
              ),
            );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/subscriptions/controllers/subscriptions_controller.dart';
import 'package:join_mp_ship/utils/user_details.dart';

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
                                            child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              8.verticalSpace,
                                              Text(resumePack.name ?? "",
                                                  style: Get
                                                      .textTheme.titleMedium),
                                              4.verticalSpace,
                                              Text(
                                                  "Daily Downloads: ${resumePack.dailyLimit ?? ""}"),
                                              Text(
                                                  "Validity: ${resumePack.durationDays}"),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child:
                                                    controller.buyingPlan
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
                                            child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              8.verticalSpace,
                                              Text(resumeTopUp.name ?? "",
                                                  style: Get
                                                      .textTheme.titleMedium),
                                              4.verticalSpace,
                                              Text(
                                                  "Daily Downloads: ${resumeTopUp.topupLimit ?? ""}"),
                                              Text(
                                                  "Validity: ${resumeTopUp.durationDays}"),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: controller.toppingUpPlan
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
                                                                    controller.topUp(
                                                                        resumeTopUp
                                                                            .id!);
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
                ],
              ),
            );
    });
  }
}

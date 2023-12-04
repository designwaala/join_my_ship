import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/subscriptions/controllers/subscriptions_controller.dart';
import 'package:join_mp_ship/utils/user_details.dart';

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Packs Purchases",
                            style: Get.textTheme.titleLarge),
                        InkWell(
                          onTap: () {
                            controller.showResumePacksPurchases.value =
                                !controller.showResumePacksPurchases.value;
                          },
                          child: Icon(
                              controller.showResumePacksPurchases.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 32),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    AnimatedCrossFade(
                        firstChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: controller.currentPackPurchases
                                    .map((resumePack) => Padding(
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
                                                Text(
                                                    UserStates.instance
                                                            .resumePacks
                                                            ?.firstWhereOrNull(
                                                                (pack) =>
                                                                    pack.id ==
                                                                    resumePack
                                                                        .purchasePack)
                                                            ?.name ??
                                                        "",
                                                    style: Get
                                                        .textTheme.titleMedium),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Top Up Purchases",
                            style: Get.textTheme.titleLarge),
                        InkWell(
                          onTap: () {
                            controller.showResumeTopUpPurchases.value =
                                !controller.showResumeTopUpPurchases.value;
                          },
                          child: Icon(
                              controller.showResumeTopUpPurchases.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 32),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    AnimatedCrossFade(
                        firstChild: Column(
                            children: controller.currentTopUpPurchases
                                .map((resumeTopUp) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            8.verticalSpace,
                                            Text(
                                                UserStates.instance.resumeTopUps
                                                        ?.firstWhereOrNull(
                                                            (topUp) =>
                                                                topUp.id ==
                                                                resumeTopUp
                                                                    .purchaseTopUp)
                                                        ?.name ??
                                                    "",
                                                style:
                                                    Get.textTheme.titleMedium),
                                            4.verticalSpace,
                                          ],
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
                  ],
                ),
              ),
            );
    });
  }
}

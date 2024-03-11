import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/extensions/date_time.dart';

import '../controllers/wallet_controller.dart';
import '../../add_credits/views/add_credits_view.dart';
import 'dart:math' as math;

class WalletView extends GetView<WalletController> {
  const WalletView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 364.h,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color(0xFF3CA2FF),
                  Color(0xFF2771E5),
                  Color(0xFF0F63EA),
                  // Color(0xFF9440FF),
                ])),
              ),
              SvgPicture.asset("assets/icons/lightening.svg"),
              Positioned(
                right: 0,
                child: Transform.rotate(
                    angle: math.pi,
                    child: SvgPicture.asset("assets/icons/lightening.svg")),
              ),
              Positioned(
                  right: 0,
                  top: 64,
                  bottom: 0,
                  child: Image.asset(
                    "assets/icons/wallet_big_coin.png",
                    height: 72.h,
                    width: 110.w,
                  )),
              Positioned(
                  right: 48,
                  top: 0,
                  bottom: 48,
                  child: Image.asset(
                    "assets/icons/wallet_small_coin.png",
                    height: 32.h,
                    width: 48.w,
                  )),
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Get.mediaQuery.viewPadding.top.verticalSpace,
                    12.verticalSpace,
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.horizontalSpace,
                        InkWell(
                          onTap: Get.back,
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text("Wallet",
                            style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const Spacer(),
                        PopupMenuButton(
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            onSelected: (item) {},
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  PopupMenuItem(
                                    onTap: () {
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        Get.toNamed(Routes.HELP);
                                      });
                                    },
                                    child: const Text('Help'),
                                  )
                                ]),
                        8.horizontalSpace
                      ],
                    ),
                    24.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text("Available Credits",
                          style: Get.textTheme.headlineSmall?.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w100)),
                    ),
                    6.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/coins.svg",
                            height: 40.h,
                            width: 40.w,
                          ),
                          20.horizontalSpace,
                          controller.isLoadingCredits.value
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : Text(
                                  controller.credit.value?.points.toString() ??
                                      "",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                        ],
                      ),
                    ),
                    28.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Get.theme.colorScheme.tertiary),
                              onPressed: () {
                                Get.toNamed(Routes.ADD_CREDITS);
                              },
                              child: const Text("Add Credits")),
                          const SizedBox(width: 20),
                          TextButton.icon(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white),
                              onPressed: () {
                                controller.getCredits();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Refresh"))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        color: Get.theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(40))),
                    child: Text("Recent Transactions",
                        style: Get.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.normal)),
                  ))
            ],
          ),
          8.verticalSpace,
          Theme(
            data: ThemeData(useMaterial3: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: WalletViewType.values
                      .map((view) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: FilterChip(
                              label: Text(view.name),
                              selected: controller.view.value == view,
                              onSelected: (value) {
                                controller.view.value = view;
                              },
                            ),
                          ))
                      .toList()),
            ),
          ),
          if (controller.isLoading.value)
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            )
          else
            controller.view.value == WalletViewType.credit
                ? Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/coins.svg",
                                  height: 24,
                                  width: 24,
                                ),
                                8.horizontalSpace,
                                Expanded(
                                  child: Text(
                                      double.tryParse(controller
                                                      .creditHistory?[index]
                                                      .amount ??
                                                  "")
                                              ?.removeZeros
                                              .toString() ??
                                          "",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      controller.creditHistory?[index]
                                                  .paymentSuccessful ==
                                              true
                                          ? Text("SUCCESSFULL",
                                              style: Get.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold))
                                          : Text("PENDING",
                                              style: Get.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors
                                                          .yellow.shade700,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                      4.verticalSpace,
                                      Text(
                                          DateTime.tryParse(controller
                                                          .creditHistory?[index]
                                                          .createdAt ??
                                                      "")
                                                  ?.getCompactDisplayDate() ??
                                              "",
                                          style: Get.textTheme.bodySmall)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: controller.creditHistory?.length ?? 0),
                  )
                : Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/coins.svg",
                                            height: 24,
                                            width: 24,
                                          ),
                                          8.horizontalSpace,
                                          Flexible(
                                            child: Text(
                                                controller.debitHistory?[index]
                                                        .pointUsed
                                                        .toString() ??
                                                    "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      4.verticalSpace,
                                      Text(
                                          controller.debitHistory?[index]
                                                  .subscriptionName ??
                                              "",
                                          style: Get.textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      controller.debitHistory?[index]
                                                  .processSuccessful ==
                                              true
                                          ? Text("SUCCESSFULL",
                                              style: Get.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold))
                                          : Text("PENDING",
                                              style: Get.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors
                                                          .yellow.shade700,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                      4.verticalSpace,
                                      Text(
                                          DateTime.tryParse(controller
                                                          .debitHistory?[index]
                                                          .createdAt ??
                                                      "")
                                                  ?.getCompactDisplayDate() ??
                                              "",
                                          style: Get.textTheme.bodySmall),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: controller.debitHistory?.length ?? 0),
                  )
        ],
      ));
    });
  }
}

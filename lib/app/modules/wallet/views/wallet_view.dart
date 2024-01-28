import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';

import '../controllers/wallet_controller.dart';
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
                  Color(0xFF9440FF),
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
                    24.verticalSpace,
                    Row(
                      children: [
                        8.horizontalSpace,
                        InkWell(
                          onTap: Get.back,
                          child: Icon(
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
                        Icon(Icons.more_vert, color: Colors.white),
                        8.horizontalSpace
                      ],
                    ),
                    32.verticalSpace,
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
                              ? SizedBox(
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
                              onPressed: () {},
                              child: Text("Add Credits"))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ));
    });
  }
}

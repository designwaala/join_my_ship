import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:pinput/pinput.dart';

import '../controllers/crew_sign_in_mobile_controller.dart';

class CrewSignInMobileView extends GetView<CrewSignInMobileController> {
  const CrewSignInMobileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        backgroundColor: Color(0xFFFbF6FF),
        appBar: AppBar(
          toolbarHeight: 60,
          title: Text('JOIN MY SHIP',
              style: Get.theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: Get.back,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Color(0xFFF3F3F3), shape: BoxShape.circle),
              child: Icon(
                Icons.keyboard_backspace_rounded,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: false,
        ),
        body: Obx(() {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      14.verticalSpace,
                      Text("Sign In",
                          style: Get.theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Text("Please sign in to your registered mobile\n number"),
                      20.verticalSpace,
                      TextFormField(
                        controller: controller.phoneController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Mobile Number",
                            prefixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("+91",
                                    style: Get.theme.textTheme.bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold)),
                              ],
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(64))),
                      ),
                      24.verticalSpace,
                      AnimatedCrossFade(
                          firstChild: SizedBox(),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Pinput(
                                length: 6,
                                controller: controller.otpController,
                                onCompleted: (_) {
                                  controller.verify();
                                },
                              ),
                              24.verticalSpace,
                            ],
                          ),
                          crossFadeState: controller.isOTPSent.value
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300)),
                      SizedBox(
                        width: double.maxFinite,
                        height: 64.h,
                        child: controller.isVerifying.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(64))),
                                onPressed: controller.isOTPSent.value
                                    ? controller.verify
                                    : controller.sendOTP,
                                child: Text(controller.isOTPSent.value
                                    ? "VERIFY"
                                    : "SEND OTP")),
                      ),
                      38.verticalSpace,
                      Center(child: Text("Or sign in with")),
                      14.verticalSpace,
                      InkWell(
                        onTap: () {
                          Get.offNamed(Routes.CREW_SIGN_IN_EMAIL);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black)),
                          child: Icon(
                            Icons.email,
                            size: 32,
                          ),
                        ),
                      ),
                      4.verticalSpace,
                      Center(child: Text('Email Id')),
                      Spacer(),
                      SizedBox(
                        width: double.maxFinite,
                        height: 64.h,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64))),
                            onPressed: () {
                              Get.toNamed(Routes.CHOOSE_USER);
                            },
                            child: Text("CREATE ACCOUNT")),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }
}

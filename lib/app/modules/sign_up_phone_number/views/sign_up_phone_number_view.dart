import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:pinput/pinput.dart';

import '../controllers/sign_up_phone_number_controller.dart';

class SignUpPhoneNumberView extends GetView<SignUpPhoneNumberController> {
  const SignUpPhoneNumberView({Key? key}) : super(key: key);
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
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64))),
                            onPressed: controller.isOTPSent.value
                                ? controller.verify
                                : controller.sendOTP,
                            child: controller.isVerifying.value
                                ? CircularProgressIndicator()
                                : Text(controller.isOTPSent.value
                                    ? "VERIFY"
                                    : "SEND OTP")),
                      ),
                      32.verticalSpace,
                      Spacer(),
                      Center(
                          child: Text("Already have an account?",
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey))),
                      32.verticalSpace,
                      SizedBox(
                        width: double.maxFinite,
                        height: 64.h,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64))),
                            onPressed: () {
                              Get.toNamed(Routes.SIGN_UP_EMAIL);
                            },
                            child: Text("LOGIN")),
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

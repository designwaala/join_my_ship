import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:pinput/pinput.dart';

import '../controllers/crew_sign_in_mobile_controller.dart';

class CrewSignInMobileView extends GetView<CrewSignInMobileController> {
  const CrewSignInMobileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        backgroundColor: const Color(0xFFFbF6FF),
        appBar: AppBar(
          title: const Text('JOIN MY SHIP'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Obx(() {
          return Form(
            key: controller.formKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        14.verticalSpace,
                        Text(
                            controller.args?.isUpdateView == true
                                ? "Update Mobile Number"
                                : "Sign In",
                            style: Get.theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        if (controller.args?.isUpdateView != true)
                          const Text(
                              "Please sign in to your registered mobile number"),
                        20.verticalSpace,
                        SizedBox(
                          height: 64,
                          child: TextFormField(
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            /* validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your phone number";
                              }
                              return null;
                            }, */
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Mobile Number",
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Container(
                                  width: 72,
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(64),
                                          bottomLeft: Radius.circular(64))),
                                  child: InkWell(
                                    onTap: () {
                                      controller.isSelectingCountryCode.value =
                                          true;
                                      showCountryPicker(
                                        context: context,
                                        onClosed: () {
                                          controller.isSelectingCountryCode
                                              .value = false;
                                        },
                                        showPhoneCode: true,
                                        onSelect: (Country country) {
                                          print(
                                              'Select country: ${country.displayName}');
                                          controller.selectedCountryCode.value =
                                              "+${country.phoneCode}";
                                          controller.isSelectingCountryCode
                                              .value = false;
                                        },
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                controller
                                                    .selectedCountryCode.value,
                                                style: Get
                                                    .theme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            Icon(controller
                                                    .isSelectingCountryCode
                                                    .value
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(64))),
                          ),
                        ),
                        24.verticalSpace,
                        AnimatedCrossFade(
                            firstChild: const SizedBox(),
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
                                    const CircularProgressIndicator(),
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
                        24.verticalSpace,
                        if (controller.showResendOTP.value) ...[
                          Center(
                              child: TextButton(
                                  onPressed: controller.sendOTP,
                                  child: Text("Resend OTP"))),
                          24.verticalSpace,
                        ] else if (controller.isOTPSent.value) ...[
                          Center(
                              child: Text(
                                  "Resend OTP in ${30 - controller.timePassed.value} seconds")),
                          24.verticalSpace
                        ],
                        if (FirebaseAuth.instance.currentUser == null) ...[
                          const Center(child: Text("Or sign in with")),
                          20.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.offAllNamed(Routes.CREW_SIGN_IN_EMAIL);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black)),
                                  child: const Icon(
                                    Icons.email,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          4.verticalSpace,
                          const Center(child: Text('Email Id')),
                          const Spacer(),
                          Divider(),
                          16.verticalSpace,
                          SizedBox(
                            width: double.maxFinite,
                            height: 64.h,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(64))),
                                onPressed: () {
                                  Get.toNamed(Routes.CHOOSE_USER);
                                },
                                child: const Text("CREATE ACCOUNT")),
                          )
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }));
  }
}

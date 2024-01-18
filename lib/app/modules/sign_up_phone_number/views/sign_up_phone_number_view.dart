import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
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
          title: Text('JOIN MY SHIP'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
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
                      Text("Sign Up",
                          style: Get.theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Text("Please sign up with your mobile\nnumber"),
                      20.verticalSpace,
                      SizedBox(
                        height: 64,
                        child: TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                  .isSelectingCountryCode.value
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
                              Get.toNamed(Routes.CREW_SIGN_IN_MOBILE);
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

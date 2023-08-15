import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator_alert_dialog.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:pinput/pinput.dart';

class ChangePasswordController extends GetxController with RequiresRecentLogin {
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool shouldObscurePassword = true.obs;
  RxBool shouldObscureConfirmPassword = true.obs;
  RxBool isLoading = false.obs;

  FToast fToast = FToast();
  final parentKey = GlobalKey();
  final formKey = GlobalKey<FormState>();

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  void changePassword() async {
    if (formKey.currentState!.validate()) {
      showDialog(
          context: Get.context!,
          builder: (context) => const AlertDialog(
                title: Text("Please wait..."),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ));
      await FirebaseAuth.instance.currentUser
          ?.updatePassword(passwordController.text.trim())
          .then((value) {
        fToast.safeShowToast(
            child: successToast("Password changed successfully"));
        Get.back();
        Get.offAndToNamed(Routes.PROFILE);
      }).onError((FirebaseException error, stackTrace) async {
        Get.back();
        fToast.safeShowToast(child: errorToast(error.toString()));
        if (error.code == "requires-recent-login") {
          await reAuthenticate();
          showDialog(
              context: Get.context!,
              builder: (context) => const AlertDialog(
                    title: Text("Please wait..."),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ));
          await FirebaseAuth.instance.currentUser
              ?.updatePassword(passwordController.text.trim())
              .then((value) {
            fToast.safeShowToast(
                child: successToast("Password changed successfully"));
            Get.back();
            Get.offAndToNamed(Routes.PROFILE);
          }).onError((error, stackTrace) {
            Get.back();
            fToast.safeShowToast(child: errorToast(error.toString()));
          });
        }
      });
    }
  }
}

mixin RequiresRecentLogin {
  RxBool isReAuthenticating = false.obs;
  Future reAuthenticate() async {
    return showDialog(
        context: Get.context!,
        builder: (context) {
          TextEditingController passwordController = TextEditingController();
          return AlertDialog(
            title: const Text("Please enter your old password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  hintText: "Email",
                  initialValue: FirebaseAuth.instance.currentUser?.email,
                  readOnly: true,
                  enabled: false,
                ),
                16.verticalSpace,
                CustomTextFormField(
                  hintText: "Password",
                  controller: passwordController,
                  obscureText: true,
                )
              ],
            ),
            actions: [
              Obx(() {
                return isReAuthenticating.value
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator()),
                        ],
                      )
                    : FilledButton(
                        onPressed: () async {
                          isReAuthenticating.value = true;
                          UserCredential? cred = await FirebaseAuth
                              .instance.currentUser
                              ?.reauthenticateWithCredential(
                                  EmailAuthProvider.credential(
                                      email: FirebaseAuth
                                              .instance.currentUser?.email ??
                                          "",
                                      password: passwordController.text));
                          isReAuthenticating.value = false;
                          Get.back(result: cred?.user != null);
                        },
                        child: const Text("Authenticate"));
              })
            ],
          );
        });
  }

  String? verificationId;
  int? forceResendingToken;
  RxInt timePassed = 0.obs;
  Timer? timer;
  RxBool isOTPSent = false.obs;
  RxBool isVerifying = false.obs;
  RxBool showResendOTP = false.obs;
  TextEditingController otpController = TextEditingController();
  UserCredential? creds;

  sendOTP() async {
    isVerifying.value = true;
    isOTPSent.value = false;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: FirebaseAuth.instance.currentUser?.phoneNumber ?? "",
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          isVerifying.value = false;
        },
        codeSent: (verificationId, forceResendingToken) {
          this.verificationId = verificationId;
          this.forceResendingToken = forceResendingToken;
          // fToast.safeShowToast(child: successToast("OTP Sent"));
          isOTPSent.value = true;
          isVerifying.value = false;
          Get.back();
          reAuthenticateOTP();
          startTimer();
        },
        forceResendingToken: forceResendingToken,
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timePassed.value >= 30) {
        showResendOTP.value = true;
        timer.cancel();
      } else {
        timePassed.value = timePassed.value + 1;
        showResendOTP.value = false;
      }
    });
  }

  Future<void> verify() async {
    isVerifying.value = true;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text);
    try {
      creds = await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential);
    } catch (e) {
      // fToast.safeShowToast(child: errorToast("$e"));
      isVerifying.value = false;
      return;
    }
    Get.back(result: creds != null);
    isVerifying.value = false;
    taskAfterReAuthentication?.call();
  }

  Function? taskAfterReAuthentication;

  Future reAuthenticateOTPDecision() async {
    return showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => AlertDialog(
              title: Text("Reauthenticate"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "This action requires reauthentication. Would you like us to send you an OTP?"),
                ],
              ),
              actionsPadding: EdgeInsets.only(right: 16, bottom: 16),
              actions: isVerifying.value
                  ? [
                      SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator())
                    ]
                  : [
                      FilledButton(onPressed: Get.back, child: Text("NO")),
                      16.horizontalSpace,
                      FilledButton(onPressed: sendOTP, child: Text("YES"))
                    ],
            ));
  }

  Future reAuthenticateOTP() async {
    return showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) {
          return Obx(() {
            return AlertDialog(
              title: const Text("Please enter OTP"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    hintText: "Phone Number",
                    initialValue:
                        FirebaseAuth.instance.currentUser?.phoneNumber,
                    readOnly: true,
                    enabled: false,
                  ),
                  16.verticalSpace,
                  AnimatedCrossFade(
                      firstChild: const SizedBox(),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Pinput(
                            length: 6,
                            controller: otpController,
                            onCompleted: (_) {
                              verify();
                            },
                          ),
                          24.verticalSpace,
                        ],
                      ),
                      crossFadeState: isOTPSent.value
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300))
                ],
              ),
              actionsPadding: EdgeInsets.only(right: 16, bottom: 16),
              actions: [
                Obx(() {
                  return isVerifying.value
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator()),
                          ],
                        )
                      : FilledButton(
                          onPressed: verify, child: const Text("Authenticate"));
                })
              ],
            );
          });
        });
  }

  _crew() {
    return const AlertDialog();
  }

  _employer() {
    return const AlertDialog();
  }
}

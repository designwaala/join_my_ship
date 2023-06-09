import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class CrewSignInMobileController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RxString selectedCountryCode = "+91".obs;

  RxBool isOTPSent = false.obs;
  RxBool isVerifying = false.obs;

  RxBool showResendOTP = false.obs;

  FToast fToast = FToast();

  final parentKey = GlobalKey();

  RxInt timePassed = 0.obs;
  Timer? timer;

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String? verificationId;
  int? forceResendingToken;
  sendOTP() async {
    isVerifying.value = true;
    isOTPSent.value = false;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${selectedCountryCode.value}${phoneController.text}",
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {},
        codeSent: (verificationId, forceResendingToken) {
          this.verificationId = verificationId;
          this.forceResendingToken = forceResendingToken;
          fToast.showToast(child: successToast("OTP Sent"));
          isOTPSent.value = true;
          startTimer();
        },
        forceResendingToken: forceResendingToken,
        codeAutoRetrievalTimeout: (verificationId) {});
    isVerifying.value = false;
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

  verify() async {
    isVerifying.value = true;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text);
    try {
      UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      fToast.showToast(child: errorToast("$e"));
      isVerifying.value = false;
      return;
    }
    if (FirebaseAuth.instance.currentUser?.emailVerified != true) {
      await FirebaseAuth.instance.signOut();
      fToast.showToast(child: errorToast("Email not Verified"));
    } else if (FirebaseAuth.instance.currentUser != null) {
      Get.offAllNamed(Routes.CREW_ONBOARDING);
      fToast.showToast(child: successToast("Authentication Successful"));
    } else {
      fToast.showToast(child: errorToast("Authentication Failed"));
    }
    isVerifying.value = false;
  }
}

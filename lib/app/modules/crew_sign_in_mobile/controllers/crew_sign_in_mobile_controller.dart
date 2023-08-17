import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/modules/splash/controllers/splash_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';

enum Miss {
  countryCode,
  mobileNumber;

  String get error {
    switch (this) {
      case Miss.countryCode:
        return "Please select your country code";
      case Miss.mobileNumber:
        return "Please enter your mobile number";
    }
  }
}

class CrewSignInMobileController extends GetxController with RedirectionMixin {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RxString selectedCountryCode = "+91".obs;

  RxList<Miss> misses = RxList.empty();
  final formKey = GlobalKey<FormState>();

  RxBool isOTPSent = false.obs;
  RxBool isVerifying = false.obs;

  RxBool showResendOTP = false.obs;

  FToast fToast = FToast();

  final parentKey = GlobalKey();

  RxInt timePassed = 0.obs;
  Timer? timer;
  RxBool isSelectingCountryCode = false.obs;

  CrewUser? crewUser;

  Function(String phoneNumber, String dialCode)? customRedirection;

  @override
  void onInit() {
    if (Get.arguments is CrewSignInMobileArguments) {
      CrewSignInMobileArguments args = Get.arguments;
      customRedirection = args.redirection;
      phoneController.text = args.phoneNumber ?? "";
      selectedCountryCode.value = args.countryCode ?? selectedCountryCode.value;
    }
    super.onInit();
  }

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
    misses.clear();
    if (phoneController.text.isEmpty) {
      misses.add(Miss.mobileNumber);
    }
    if (misses.isNotEmpty) {
      return;
    }

    isVerifying.value = true;
    isOTPSent.value = false;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${selectedCountryCode.value}${phoneController.text}",
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          isVerifying.value = false;
        },
        codeSent: (verificationId, forceResendingToken) {
          this.verificationId = verificationId;
          this.forceResendingToken = forceResendingToken;
          fToast.safeShowToast(child: successToast("OTP Sent"));
          isOTPSent.value = true;
          isVerifying.value = false;
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

  verify() async {
    isVerifying.value = true;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text);
    try {
      FirebaseAuth.instance.currentUser == null
          ? await FirebaseAuth.instance.signInWithCredential(credential)
          : FirebaseAuth.instance.currentUser?.phoneNumber == null
              ? await FirebaseAuth.instance.currentUser
                  ?.linkWithCredential(credential)
              : await FirebaseAuth.instance.currentUser
                  ?.updatePhoneNumber(credential);
      await redirection(
          customRedirection: customRedirection == null
              ? null
              : () {
                  customRedirection?.call(
                      phoneController.text, selectedCountryCode.value);
                });
    } catch (e) {
      fToast.safeShowToast(child: errorToast("$e"));
      isVerifying.value = false;
      return;
    }
/*     if (FirebaseAuth.instance.currentUser?.emailVerified != true) {
      await FirebaseAuth.instance.signOut();
      fToast.safeShowToast(child: errorToast("Email not Verified"));
    } else if (FirebaseAuth.instance.currentUser != null) {
      if (customRedirection != null) {
        customRedirection!(phoneController.text, selectedCountryCode.value);
      } else {
        crewUser = await getIt<CrewUserProvider>().getCrewUser();
        UserStates.instance.crewUser = crewUser;
        if (crewUser?.userTypeKey == 3) {
          Get.offAllNamed(crewUser?.screenCheck == 1
              ? (crewUser?.isVerified == 1
                  ? Routes.HOME
                  : Routes.ACCOUNT_UNDER_VERIFICATION)
              : Routes.EMPLOYER_CREATE_USER);
        } else {
          if (crewUser?.screenCheck == 3) {
            if (crewUser?.isVerified == 1) {
              Get.offAllNamed(Routes.HOME);
            } else {
              Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
            }
          } else {
            Get.offAllNamed(Routes.CREW_ONBOARDING);
          }
        }
      }
      fToast.safeShowToast(child: successToast("Authentication Successful"));
    } else {
      fToast.safeShowToast(child: errorToast("Authentication Failed"));
    } */
    isVerifying.value = false;
  }
}

class CrewSignInMobileArguments {
  final Function(String phoneNumber, String dialCode)? redirection;
  final String? phoneNumber;
  final String? countryCode;

  const CrewSignInMobileArguments(
      {this.redirection, this.countryCode, this.phoneNumber});
}

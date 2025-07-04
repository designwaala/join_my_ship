import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';
import 'package:join_my_ship/app/modules/splash/controllers/splash_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';

class SignUpPhoneNumberController extends GetxController with RedirectionMixin {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RxString selectedCountryCode = "+91".obs;

  RxBool isOTPSent = false.obs;
  RxBool isVerifying = false.obs;

  FToast fToast = FToast();

  final parentKey = GlobalKey();

  RxBool isSelectingCountryCode = false.obs;

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  String? verificationId;
  sendOTP() async {
    // isOTPSent.value = true;
    // isVerifying.value = false;
    // update();
    isVerifying.value = true;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${selectedCountryCode.value}${phoneController.text}",
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          isVerifying.value = false;
        },
        codeSent: (verificationId, forceResendingToken) {
          this.verificationId = verificationId;
          fToast.safeShowToast(child: successToast("OTP Sent"));
          isOTPSent.value = true;
          isVerifying.value = false;
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  verify() async {
    // Get.offAllNamed(Routes.SIGN_UP_EMAIL,
    //     arguments: SignUpEmailArguments(
    //         signUpType: Get.arguments["company_type"],
    //         smsCode: otpController.text,
    //         verificationId: verificationId));
    isVerifying.value = true;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text);
    try {
      UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCred.additionalUserInfo?.isNewUser == false) {
        if (PreferencesHelper.instance.userLink == null) {
          fToast.safeShowToast(
              child: errorToast("This mobile number is already registered."));
        } else {
          redirection();
        }
      } else if (FirebaseAuth.instance.currentUser != null) {
        Get.offAllNamed(Routes.SIGN_UP_EMAIL);
        fToast.safeShowToast(child: successToast("Authentication Successful"));
      } else {
        fToast.safeShowToast(child: errorToast("Authentication Failed"));
      }
    } catch (e) {
      fToast.safeShowToast(child: errorToast("Authentication Failed"));
    }
    isVerifying.value = false;
  }
}

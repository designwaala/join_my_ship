import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class SignUpPhoneNumberController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  RxBool isOTPSent = false.obs;
  RxBool isVerifying = false.obs;

  FToast fToast = FToast();

  final parentKey = GlobalKey();

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  String? verificationId;
  sendOTP() async {
    isVerifying.value = true;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {},
        codeSent: (verificationId, forceResendingToken) {
          this.verificationId = verificationId;
          fToast.showToast(child: successToast("OTP Sent"));
          isOTPSent.value = true;
        },
        codeAutoRetrievalTimeout: (verificationId) {});
    isVerifying.value = false;
  }

  verify() async {
    isVerifying.value = true;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text);
    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAllNamed(Routes.SIGN_UP_EMAIL,
          arguments: SignUpEmailArguments(
              signUpType: Get.arguments["company_type"],
              smsCode: otpController.text,
              verificationId: verificationId));
      fToast.showToast(child: successToast("Authentication Successful"));
    } else {
      fToast.showToast(child: errorToast("Authentication Failed"));
    }
    isVerifying.value = false;
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';

class EmailVerificationWaitingController extends GetxController {
  RxBool isResendingEmail = false.obs;
  RxBool isSigningOut = false.obs;
  // Timer? _timer;

  @override
  void onInit() {
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
    //   await FirebaseAuth.instance.currentUser?.reload();
    //   if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
    //     Get.offNamed(Routes.CREW_ONBOARDING);
    //   }
    // });
    super.onInit();
  }

  Future<void> signOut() async {
    isSigningOut.value = true;
    await FirebaseAuth.instance.signOut();
    await PreferencesHelper.instance.clearAll();
    Get.back();
    isSigningOut.value = false;
  }

  resendEmail() async {
    isResendingEmail.value = true;
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    isResendingEmail.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // _timer?.cancel();
  }
}

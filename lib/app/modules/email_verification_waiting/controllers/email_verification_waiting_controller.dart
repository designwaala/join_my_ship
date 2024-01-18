import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';

class EmailVerificationWaitingController extends GetxController {
  RxBool isResendingEmail = false.obs;
  RxBool isSigningOut = false.obs;
  RxBool isRefreshing = false.obs;
  bool isCrew = true;
  // Timer? _timer;
  EmailVerificationArguments? args;
  @override
  void onInit() {
    if (Get.arguments is EmailVerificationArguments) {
      final args = Get.arguments as EmailVerificationArguments;
      isCrew = args.isCrew == true;
    }
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

  Future<void> refresh() async {
    isRefreshing.value = true;
    await FirebaseAuth.instance.currentUser?.reload();
    isRefreshing.value = false;
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

class EmailVerificationArguments {
  final bool? isCrew;
  final Function? redirection;
  const EmailVerificationArguments({this.isCrew, this.redirection});
}

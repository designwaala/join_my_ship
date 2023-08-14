import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/modules/email_verification_waiting/controllers/email_verification_waiting_controller.dart';

import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  CrewUser? user;

  @override
  void onInit() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    super.onInit();
    animationController.forward(from: 0);
    redirection();
  }

  redirection() async {
    try {
      await Future.wait([
        FirebaseAuth.instance.currentUser == null ||
                PreferencesHelper.instance.accessToken.isEmpty
            ? Future.value(null)
            : getIt<CrewUserProvider>()
                .getCrewUser()
                .then((value) => user = value),
        Future.delayed(const Duration(seconds: 3))
      ]);
    } catch (e) {
      print("$e");
    }
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signOut();
      await PreferencesHelper.instance.clearAll();
      Get.offAllNamed(Routes.INFO);
      return;
    }
    //CREW FLOW
    if (PreferencesHelper.instance.isCrew == true || user?.userTypeKey == 2) {
      if (FirebaseAuth.instance.currentUser?.emailVerified != true) {
        Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING,
            arguments: const EmailVerificationArguments(isCrew: true));
      } else if (user?.screenCheck == 3) {
        if (user?.isVerified == 1) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
        }
      } else {
        Get.offAllNamed(Routes.CREW_ONBOARDING);
      }
      return;
    }
    //EMPLOYER FLOW
    else {
      if (PreferencesHelper.instance.employerType == null ||
          FirebaseAuth.instance.currentUser?.phoneNumber == null) {
        Get.offAllNamed(Routes.CHOOSE_EMPLOYER);
      } else if (FirebaseAuth.instance.currentUser?.email?.nullIfEmpty() ==
          null) {
        Get.offAllNamed(Routes.SIGN_UP_EMAIL);
      } else if (FirebaseAuth.instance.currentUser?.emailVerified != true) {
        Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING,
            arguments: const EmailVerificationArguments(isCrew: false));
      } else if (user?.screenCheck == 1) {
        if (user?.isVerified == 1) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
        }
      } else {
        Get.offAllNamed(Routes.EMPLOYER_CREATE_USER);
      }
      return;
    }
    /* Get.offAllNamed(FirebaseAuth.instance.currentUser == null
        ? Routes.INFO
        : FirebaseAuth.instance.currentUser?.emailVerified == true
            ? user?.id != null
                ? Routes.HOME
                : (PreferencesHelper.instance.isCrew == true ||
                        user?.userTypeKey == 2)
                    ? user?.screenCheck == 3
                        ? Routes.HOME
                        : Routes.CREW_ONBOARDING
                    : user?.screenCheck == 1
                        ? Routes.HOME
                        : Routes.EMPLOYER_CREATE_USER
            : Routes.EMAIL_VERIFICATION_WAITING); */
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

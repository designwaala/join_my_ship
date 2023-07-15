import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void onInit() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    super.onInit();
    animationController.forward(from: 0);
    redirection();
    getFCMToken();
  }

  getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  redirection() async {
    await Future.wait([Future.delayed(const Duration(seconds: 3))]);

    Get.offAllNamed(FirebaseAuth.instance.currentUser == null
        ? Routes.INFO
        : FirebaseAuth.instance.currentUser?.emailVerified == true
            ? PreferencesHelper.instance.isCrew == true
                ? Routes.CREW_ONBOARDING
                : Routes.EMPLOYER_CREATE_USER
            : Routes.EMAIL_VERIFICATION_WAITING);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

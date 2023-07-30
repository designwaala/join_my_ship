import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';

import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';

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
    getFCMToken();
  }

  getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
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
    }
    Get.offAllNamed(FirebaseAuth.instance.currentUser == null
        ? Routes.INFO
        : FirebaseAuth.instance.currentUser?.emailVerified == true
            ? user?.id != null
                ? Routes.HOME
                : (PreferencesHelper.instance.isCrew == true ||
                        user?.userTypeKey == 2)
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

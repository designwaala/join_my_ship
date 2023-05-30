import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';

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
    await Future.delayed(const Duration(seconds: 3));
    Get.toNamed(FirebaseAuth.instance.currentUser == null
        ? Routes.INFO
        : FirebaseAuth.instance.currentUser?.emailVerified == true
            ? Routes.CREW_ONBOARDING
            : Routes.EMAIL_VERIFICATION_WAITING);
  }
}

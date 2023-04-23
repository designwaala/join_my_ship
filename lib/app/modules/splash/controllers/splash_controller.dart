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
  }

  redirection() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.toNamed(Routes.INFO);
  }
}

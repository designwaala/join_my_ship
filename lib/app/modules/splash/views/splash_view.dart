import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
        backgroundColor: Get.theme.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedBuilder(
                  animation: controller.animationController,
                  builder: (context, child) {
                    return SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: controller.animationController.value * 256,
                      height: controller.animationController.value * 256,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    );
                  }),
            ),
          ],
        ));
  }
}

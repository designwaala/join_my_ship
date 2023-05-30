import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/step1.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/step2.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/step3.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

import '../controllers/crew_onboarding_controller.dart';

class CrewOnboardingView extends GetView<CrewOnboardingController> {
  const CrewOnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          if (controller.step.value > 1) {
            controller.step.value = controller.step.value - 1;
            return false;
          }
          return true;
        },
        child: Scaffold(
          key: controller.parentKey,
          backgroundColor: const Color(0xFFFbF6FF),
          appBar: AppBar(
            toolbarHeight: 70,
            title: Text('CREW',
                style: Get.theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            backgroundColor: Colors.white,
            leading: Navigator.of(context).canPop()
                ? InkWell(
                    onTap: () {
                      if (controller.step.value > 1) {
                        controller.step.value = controller.step.value - 1;
                        return;
                      }
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF3F3F3), shape: BoxShape.circle),
                      child: const Icon(
                        Icons.keyboard_backspace_rounded,
                        color: Colors.black,
                      ),
                    ),
                  )
                : null,
            centerTitle: false,
          ),
          body: controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : () {
                  switch (controller.step.value) {
                    case 1:
                      return CrewonboardingStep1();
                    case 2:
                      return CrewOnboardingStep2();
                    case 3:
                      return CrewOnboardingStep3();
                  }
                }(),
        ),
      );
    });
  }

  TextStyle? get _headingStyle =>
      Get.textTheme.bodyMedium?.copyWith(color: Get.theme.primaryColor);
}

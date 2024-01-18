import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/crew-onboarding/views/widgets/step1.dart';
import 'package:join_my_ship/app/modules/crew-onboarding/views/widgets/step2.dart';
import 'package:join_my_ship/app/modules/crew-onboarding/views/widgets/step3.dart';

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
            controller.getAndSetCurrentScreen();
            return false;
          }
          return true;
        },
        child: Scaffold(
          key: controller.parentKey,
          backgroundColor: const Color(0xFFFbF6FF),
          appBar: AppBar(
            title: const Text('CREW'),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () {
                if (controller.step.value > 1) {
                  controller.step.value = controller.step.value - 1;
                  controller.getAndSetCurrentScreen();
                  return;
                }
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.keyboard_backspace_rounded,
                  color: Colors.black,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              if ((controller.step.value == 1 &&
                      controller.crewUser?.id != null) ||
                  (controller.step.value == 2 &&
                      controller.userDetails?.id != null))
                TextButton(
                    onPressed: () {
                      controller.step.value = controller.step.value + 1;
                      controller.getAndSetCurrentScreen();
                    },
                    child: const Text("Skip"))
            ],
          ),
          body: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : () {
                  switch (controller.step.value) {
                    case 1:
                      return const CrewonboardingStep1();
                    case 2:
                      return const CrewOnboardingStep2();
                    case 3:
                      return const CrewOnboardingStep3();
                  }
                }(),
        ),
      );
    });
  }

  TextStyle? get headingStyle =>
      Get.textTheme.bodyMedium?.copyWith(color: Get.theme.primaryColor);
}

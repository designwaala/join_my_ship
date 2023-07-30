import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/job_post/views/widgets/step1.dart';
import 'package:join_mp_ship/app/modules/job_post/views/widgets/step2.dart';
import 'package:join_mp_ship/app/modules/job_post/views/widgets/step3.dart';

import '../controllers/job_post_controller.dart';

class JobPostView extends GetView<JobPostController> {
  const JobPostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.parentKey,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text('JOB POST',
            style: Get.theme.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            if (controller.currentStep.value > 1) {
              controller.currentStep.value = controller.currentStep.value - 1;
            } else {
              Get.back();
            }
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
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.currentStep.value == 1
            ? JobPostStep1()
            : controller.currentStep.value == 2
                ? JobPostStep2()
                : JobPostStep3();
      }),
    );
  }
}

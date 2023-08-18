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
        title: const Text('JOB POST'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            if (controller.currentStep.value <= 1) {
              Get.back();
            } else {
              controller.currentStep.value = controller.currentStep.value - 1;
            }
          },
          child: Icon(Icons.arrow_back),
        ),
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

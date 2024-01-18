import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/crew_referral/views/widgets/job_form.dart';
import 'package:join_my_ship/app/modules/crew_referral/views/widgets/job_preview.dart';

import '../controllers/crew_referral_controller.dart';

class CrewReferralView extends GetView<CrewReferralController> {
  const CrewReferralView({Key? key}) : super(key: key);
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
            if (controller.previewJob.value) {
              controller.previewJob.value = false;
            } else {
              Get.back();
            }
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(() {
        return controller.previewJob.value
            ? const JobPreview()
            : const JobForm();
      }),
    );
  }
}

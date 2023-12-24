import 'package:get/get.dart';

import '../controllers/job_post_under_verification_controller.dart';

class JobPostUnderVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobPostUnderVerificationController>(
      () => JobPostUnderVerificationController(),
    );
  }
}

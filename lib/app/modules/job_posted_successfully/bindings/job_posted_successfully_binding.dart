import 'package:get/get.dart';

import '../controllers/job_posted_successfully_controller.dart';

class JobPostedSuccessfullyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobPostedSuccessfullyController>(
      () => JobPostedSuccessfullyController(),
    );
  }
}

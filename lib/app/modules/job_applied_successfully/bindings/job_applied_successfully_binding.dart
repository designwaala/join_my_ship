import 'package:get/get.dart';

import '../controllers/job_applied_successfully_controller.dart';

class JobAppliedSuccessfullyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobAppliedSuccessfullyController>(
      () => JobAppliedSuccessfullyController(),
    );
  }
}

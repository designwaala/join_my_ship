import 'package:get/get.dart';

import '../controllers/job_opening_controller.dart';

class JobOpeningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobOpeningController>(
      () => JobOpeningController(),
    );
  }
}

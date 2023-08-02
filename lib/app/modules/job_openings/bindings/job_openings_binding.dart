import 'package:get/get.dart';

import '../controllers/job_openings_controller.dart';

class JobOpeningsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobOpeningsController>(
      () => JobOpeningsController(),
    );
  }
}

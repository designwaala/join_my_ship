import 'package:get/get.dart';

import '../controllers/job_post_controller.dart';

class JobPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobPostController>(
      () => JobPostController(),
    );
  }
}

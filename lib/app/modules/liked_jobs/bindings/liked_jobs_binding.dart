import 'package:get/get.dart';

import '../controllers/liked_jobs_controller.dart';

class LikedJobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikedJobsController>(
      () => LikedJobsController(),
    );
  }
}

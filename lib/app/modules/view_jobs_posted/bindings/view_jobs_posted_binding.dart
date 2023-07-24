import 'package:get/get.dart';

import '../controllers/view_jobs_posted_controller.dart';

class ViewJobsPostedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewJobsPostedController>(
      () => ViewJobsPostedController(),
    );
  }
}

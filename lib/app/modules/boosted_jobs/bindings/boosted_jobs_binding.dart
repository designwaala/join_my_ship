import 'package:get/get.dart';

import '../controllers/boosted_jobs_controller.dart';

class BoostedJobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoostedJobsController>(
      () => BoostedJobsController(),
    );
  }
}

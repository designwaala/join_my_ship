import 'package:get/get.dart';

import '../controllers/boosted_jobs_controller.dart';

class BoostedJobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoostedJobsController>(() => BoostedJobsController());
  }
}

class BoostedTagJobsBinding extends Bindings {
  final String tag;
  BoostedTagJobsBinding(this.tag);

  @override
  void dependencies() {
    Get.lazyPut<BoostedJobsController>(() => BoostedJobsController(),
        fenix: true, tag: tag);
  }
}

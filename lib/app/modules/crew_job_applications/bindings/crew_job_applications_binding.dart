import 'package:get/get.dart';

import '../controllers/crew_job_applications_controller.dart';

class CrewJobApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrewJobApplicationsController>(
      () => CrewJobApplicationsController(),
    );
  }
}

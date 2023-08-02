import 'package:get/get.dart';

import '../controllers/employer_job_applications_controller.dart';

class EmployerJobApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployerJobApplicationsController>(
      () => EmployerJobApplicationsController(),
    );
  }
}

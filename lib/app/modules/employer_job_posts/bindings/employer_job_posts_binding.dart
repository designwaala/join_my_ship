import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/employer_job_posts/controllers/employer_job_posts_controller.dart';

import '../../employer_job_applications/controllers/employer_job_applications_controller.dart';

class EmployerJobPostsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployerJobPostsController>(
      () => EmployerJobPostsController(),
    );
    Get.lazyPut<EmployerJobApplicationsController>(
      () => EmployerJobApplicationsController(),
    );
  }
}

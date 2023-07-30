import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/employer_jobs/controllers/employer_job_posts_controller.dart';

import 'package:join_mp_ship/app/modules/job_post/controllers/job_post_controller.dart';

import '../controllers/employer_job_applications_controller.dart';

class EmployerJobsBinding extends Bindings {
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

import 'package:get/get.dart';

import '../controllers/applicant_detail_controller.dart';

class ApplicantDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicantDetailController>(
      () => ApplicantDetailController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/crew_sign_in_mobile_controller.dart';

class CrewSignInMobileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrewSignInMobileController>(
      () => CrewSignInMobileController(),
    );
  }
}

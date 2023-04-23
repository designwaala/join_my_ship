import 'package:get/get.dart';

import '../controllers/crew_sign_in_controller.dart';

class CrewSignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrewSignInController>(
      () => CrewSignInController(),
    );
  }
}

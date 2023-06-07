import 'package:get/get.dart';

import '../controllers/crew_onboarding_controller.dart';

class CrewOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrewOnboardingController>(
      () => CrewOnboardingController(),
    );
  }
}

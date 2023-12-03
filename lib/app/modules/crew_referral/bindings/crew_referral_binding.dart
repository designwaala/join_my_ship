import 'package:get/get.dart';

import '../controllers/crew_referral_controller.dart';

class CrewReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrewReferralController>(
      () => CrewReferralController(),
    );
  }
}

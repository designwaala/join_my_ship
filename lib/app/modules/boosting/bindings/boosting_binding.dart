import 'package:get/get.dart';

import '../controllers/boosting_controller.dart';

class BoostingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoostingController>(
      () => BoostingController(),
    );
  }
}

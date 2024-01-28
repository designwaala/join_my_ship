import 'package:get/get.dart';

import '../controllers/add_credits_controller.dart';

class AddCreditsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCreditsController>(
      () => AddCreditsController(),
    );
  }
}

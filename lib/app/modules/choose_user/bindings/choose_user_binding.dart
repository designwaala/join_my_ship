import 'package:get/get.dart';

import '../controllers/choose_user_controller.dart';

class ChooseUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseUserController>(
      () => ChooseUserController(),
    );
  }
}

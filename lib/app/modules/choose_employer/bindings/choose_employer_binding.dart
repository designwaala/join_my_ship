import 'package:get/get.dart';

import '../controllers/choose_employer_controller.dart';

class ChooseEmployerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseEmployerController>(
      () => ChooseEmployerController(),
    );
  }
}

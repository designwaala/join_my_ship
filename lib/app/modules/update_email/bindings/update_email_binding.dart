import 'package:get/get.dart';

import '../controllers/update_email_controller.dart';

class UpdateEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateEmailController>(
      () => UpdateEmailController(),
    );
  }
}

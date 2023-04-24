import 'package:get/get.dart';

import '../controllers/sign_up_email_controller.dart';

class SignUpEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpEmailController>(
      () => SignUpEmailController(),
    );
  }
}

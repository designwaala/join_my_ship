import 'package:get/get.dart';

import '../controllers/email_verification_waiting_controller.dart';

class EmailVerificationWaitingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerificationWaitingController>(
      () => EmailVerificationWaitingController(),
    );
  }
}

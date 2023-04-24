import 'package:get/get.dart';

import '../controllers/sign_up_phone_number_controller.dart';

class SignUpPhoneNumberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpPhoneNumberController>(
      () => SignUpPhoneNumberController(),
    );
  }
}

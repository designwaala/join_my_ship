import 'package:get/get.dart';

import '../controllers/account_under_verification_controller.dart';

class AccountUnderVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountUnderVerificationController>(
      () => AccountUnderVerificationController(),
    );
  }
}

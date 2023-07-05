import 'package:get/get.dart';

import '../controllers/employer_create_user_controller.dart';

class EmployerCreateUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployerCreateUserController>(
      () => EmployerCreateUserController(),
    );
  }
}

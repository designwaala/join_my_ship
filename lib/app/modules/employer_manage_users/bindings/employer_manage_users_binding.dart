import 'package:get/get.dart';

import '../controllers/employer_manage_users_controller.dart';

class EmployerManageUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployerManageUsersController>(
      () => EmployerManageUsersController(),
    );
  }
}

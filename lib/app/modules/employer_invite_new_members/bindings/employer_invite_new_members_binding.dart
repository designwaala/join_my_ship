import 'package:get/get.dart';

import '../controllers/employer_invite_new_members_controller.dart';

class EmployerInviteNewMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployerInviteNewMembersController>(
      () => EmployerInviteNewMembersController(),
    );
  }
}

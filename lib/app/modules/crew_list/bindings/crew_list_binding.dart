import 'package:get/get.dart';

import '../controllers/crew_list_controller.dart';

class CrewListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrewListController>(
      () => CrewListController(),
    );
  }
}

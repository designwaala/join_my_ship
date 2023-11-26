import 'package:get/get.dart';

import '../controllers/crew_detail_controller.dart';

class CrewDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrewDetailController>(
      () => CrewDetailController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/boosted_crew_profiles_controller.dart';

class BoostedCrewProfilesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoostedCrewProfilesController>(
      () => BoostedCrewProfilesController(),
    );
  }
}

class BoostedTagCrewProfilesBinding extends Bindings {
    final String tag;
  BoostedTagCrewProfilesBinding(this.tag);

  @override
  void dependencies() {
    Get.lazyPut<BoostedCrewProfilesController>(
      () => BoostedCrewProfilesController(),
      tag: tag
    );
  }
}

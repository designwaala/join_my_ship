import 'package:get/get.dart';

import '../controllers/connectivity_lost_controller.dart';

class ConnectivityLostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectivityLostController>(
      () => ConnectivityLostController(),
    );
  }
}

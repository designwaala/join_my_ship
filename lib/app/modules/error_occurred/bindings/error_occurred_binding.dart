import 'package:get/get.dart';

import '../controllers/error_occurred_controller.dart';

class ErrorOccurredBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ErrorOccurredController>(
      () => ErrorOccurredController(),
    );
  }
}

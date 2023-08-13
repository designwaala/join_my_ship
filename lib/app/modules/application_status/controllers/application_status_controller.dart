import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';

class ApplicationStatusController extends GetxController {
  ApplicationStatusArguments? args;

  @override
  void onInit() {
    if (Get.arguments is ApplicationStatusArguments?) {
      args = Get.arguments;
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class ApplicationStatusArguments {
  final Application? application;
  const ApplicationStatusArguments({this.application});
}

import 'package:get/get.dart';

class SuccessController extends GetxController {
  SuccessArguments? args;

  @override
  void onInit() {
    if (Get.arguments is SuccessArguments?) {
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

class SuccessArguments {
  final String? message;
  final Function()? redirection;
  const SuccessArguments({this.message, this.redirection});
}

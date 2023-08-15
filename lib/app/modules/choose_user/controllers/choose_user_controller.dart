import 'package:get/get.dart';

class ChooseUserController extends GetxController {
  //TODO: Implement ChooseUserController

  final count = 0.obs;
  ChooseUserArguments? args;
  @override
  void onInit() {
    if (Get.arguments is ChooseUserArguments?) {
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

  void increment() => count.value++;
}

class ChooseUserArguments {
  final Function()? redirection;
  const ChooseUserArguments({this.redirection});
}

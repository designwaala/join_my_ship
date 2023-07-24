import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 1.obs;

  final count = 0.obs;

  RxBool showJobButtons = false.obs;
  @override
  void onInit() {
    super.onInit();
  }
}

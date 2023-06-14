import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 1.obs;

  final count = 0.obs;
  @override
  void onInit() {
    print("home init");
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

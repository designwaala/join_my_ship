import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(Routes.HOME);
    });
    super.onInit();
  }
}

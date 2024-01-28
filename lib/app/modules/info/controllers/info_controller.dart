import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/info_model.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/remote_config.dart';

class InfoController extends GetxController {
  CarouselController carouselController = CarouselController();
  RxInt currentIndex = 0.obs;

  List<InfoModel>? infoModel = RemoteConfigUtils.instance.info;

  onNextPressed() {
    if (currentIndex.value < (infoModel?.length ?? 0) - 1) {
      currentIndex.value = currentIndex.value + 1;
      carouselController.animateToPage(currentIndex.value);
      return;
    }
    Get.toNamed(Routes.CREW_SIGN_IN_EMAIL);
  }
}

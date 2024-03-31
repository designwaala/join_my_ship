import 'package:get/get.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';

class HelpController extends GetxController {
  RxBool isRatingGiven = (PreferencesHelper.instance.ratingGiven == true).obs;

  @override
  void onInit() {
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

import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/boosting_model.dart';
import 'package:join_mp_ship/app/data/providers/boosting_provider.dart';
import 'package:join_mp_ship/main.dart';

class BoostingController extends GetxController {
  RxBool isLoading = false.obs;
  Boosting? boosting;
  Rx<BoostingViewType> view = BoostingViewType.jobPost.obs;

  @override
  void onInit() {
    super.onInit();
    getBoostings();
  }

  Future<void> getBoostings() async {
    isLoading.value = true;
    boosting = await getIt<BoostingProvider>().getBoosting();
    isLoading.value = false;
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

enum BoostingViewType {
  jobPost,
  profile;
}

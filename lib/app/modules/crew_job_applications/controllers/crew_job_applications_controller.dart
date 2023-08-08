import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/providers/application_provider.dart';
import 'package:join_mp_ship/main.dart';

class CrewJobApplicationsController extends GetxController {
  RxList<Application> applications = RxList.empty();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getJobApplications();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> getJobApplications() async {
    isLoading.value = true;
    applications.value = await getIt<ApplicationProvider>().getAppliedJobList();
    isLoading.value = false;
  }
}

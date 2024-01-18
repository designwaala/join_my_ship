import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/crew_user_model.dart';
import 'package:join_my_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_my_ship/main.dart';

class CompaniesController extends GetxController {
  List<CrewUser> companies = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    _getCompanies();
    super.onInit();
  }

  Future<void> _getCompanies() async {
    isLoading.value = true;
    companies = await getIt<CrewUserProvider>().getAllCompanies();
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

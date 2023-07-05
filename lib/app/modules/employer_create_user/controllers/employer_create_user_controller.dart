import 'package:get/get.dart';

import '../../../data/models/country_model.dart';
import '../../../data/models/state_model.dart';

class EmployerCreateUserController extends GetxController {
  //TODO: Implement EmployerCreateUserController
  Rxn<StateModel> state = Rxn();
  Rxn<Country> country = Rxn();
  List<Country> countries = [];

  RxList<StateModel> states = RxList.empty();

  final count = 0.obs;
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

  void increment() => count.value++;
}

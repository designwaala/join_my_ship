import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/utils/extensions/string_extensions.dart';

class ErrorOccurredController extends GetxController {
  //TODO: Implement ErrorOccurredController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    print([
      FirebaseAuth.instance.currentUser != null,
      UserStates.instance.crewUser != null,
      UserStates.instance.isCrew == true,
      FirebaseAuth.instance.currentUser?.email?.nullIfEmpty() != null,
      FirebaseAuth.instance.currentUser?.emailVerified == true,
      FirebaseAuth.instance.currentUser?.phoneNumber != null
    ]);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

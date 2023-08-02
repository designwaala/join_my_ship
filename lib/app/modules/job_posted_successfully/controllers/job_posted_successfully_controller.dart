import 'package:get/get.dart';

class JobPostedSuccessfullyController extends GetxController {
  JobPostedSuccessfullyArguments? args;

  @override
  void onInit() {
    if (Get.arguments is JobPostedSuccessfullyArguments?) {
      args = Get.arguments;
    }
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

class JobPostedSuccessfullyArguments {
  final String? message;
  const JobPostedSuccessfullyArguments({this.message});
}

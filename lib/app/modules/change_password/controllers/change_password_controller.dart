import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class ChangePasswordController extends GetxController {
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool shouldObscurePassword = true.obs;
  RxBool shouldObscureConfirmPassword = true.obs;
  RxBool isLoading = false.obs;

  FToast fToast = FToast();
  final parentKey = GlobalKey();
  final formKey = GlobalKey<FormState>();

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  void changePassword() async {
    if (formKey.currentState!.validate()) {
      Get.to(const CircularProgressIndicatorWidget());
      await FirebaseAuth.instance.currentUser
          ?.updatePassword(passwordController.text.trim())
          .then((value) {
        fToast.safeShowToast(
            child: successToast("Password changed successfully"));
        Get.back();
        Get.offAndToNamed(Routes.PROFILE);
      }).onError((error, stackTrace) {
        fToast.safeShowToast(child: errorToast(error.toString()));
      });
      Get.back();
    }
  }
}

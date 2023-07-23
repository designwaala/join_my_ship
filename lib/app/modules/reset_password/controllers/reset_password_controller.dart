import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class ResetPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();

  FToast fToast = FToast();
  final parentKey = GlobalKey();
  final formKey = GlobalKey<FormState>();

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      Get.to(const CircularProgressIndicatorWidget());
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim())
          .then((value) {
        fToast.safeShowToast(child: successToast("Passowrd reset email sent"));
        Get.back();
        Get.offAndToNamed(Routes.RESET_PASSWORD_EMAIL_VERIFICATION);
      }).onError((error, stackTrace) {
        Get.back();
        fToast.safeShowToast(child: errorToast(error.toString()));
      });
    }
  }
}

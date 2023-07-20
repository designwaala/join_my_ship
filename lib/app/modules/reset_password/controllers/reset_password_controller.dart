import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/reset_password/views/check_email_view.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class ResetPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();

  FToast fToast = FToast();
  final parentKey = GlobalKey();

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  Future resetPassword() async {
    Get.defaultDialog(
      title: "Please wait",
      content: const CircularProgressIndicator(),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      fToast.safeShowToast(child: successToast("Passowrd reset email sent"));
      Get.back();
      Get.off(const CheckEmailView());
    } on FirebaseAuthException catch (error) {
      Get.back();
      fToast.safeShowToast(child: errorToast(error.message.toString()));
    }
    // return success;
  }
}

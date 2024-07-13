import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/providers/toggle_password_provider.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/widgets/circular_progress_indicator_alert_dialog.dart';
import 'package:join_my_ship/widgets/circular_progress_indicator_widget.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';

class ResetPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();

  FToast fToast = FToast();
  final parentKey = GlobalKey();
  final formKey = GlobalKey<FormState>();

  RxBool checkEmailView = false.obs;
  RxBool isResendingEmail = false.obs;

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  Future<void> resendEmail() async {
    isResendingEmail.value = true;
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
    isResendingEmail.value = false;
  }

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                shape: alertDialogShape,
                title: const Text("Please wait..."),
                content: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ));
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim())
          .then((value) {
        getIt<TogglePasswordProvider>().passwordResetSetRequestInitiate(email: emailController.text.trim());
        fToast.safeShowToast(child: successToast("Passowrd reset email sent"));
        Get.back();
        checkEmailView.value = true;
      }).onError((error, stackTrace) {
        Get.back();
        fToast.safeShowToast(child: errorToast(error.toString()));
      });
    }
  }
}

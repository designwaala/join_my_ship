import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator_alert_dialog.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class ChangePasswordController extends GetxController with RequiresRecentLogin {
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
      showDialog(
          context: Get.context!,
          builder: (context) => const AlertDialog(
                title: Text("Please wait..."),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ));
      await FirebaseAuth.instance.currentUser
          ?.updatePassword(passwordController.text.trim())
          .then((value) {
        fToast.safeShowToast(
            child: successToast("Password changed successfully"));
        Get.back();
        Get.offAndToNamed(Routes.PROFILE);
      }).onError((FirebaseException error, stackTrace) async {
        Get.back();
        fToast.safeShowToast(child: errorToast(error.toString()));
        if (error.code == "requires-recent-login") {
          await reAuthenticate();
          showDialog(
              context: Get.context!,
              builder: (context) => const AlertDialog(
                    title: Text("Please wait..."),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ));
          await FirebaseAuth.instance.currentUser
              ?.updatePassword(passwordController.text.trim())
              .then((value) {
            fToast.safeShowToast(
                child: successToast("Password changed successfully"));
            Get.back();
            Get.offAndToNamed(Routes.PROFILE);
          }).onError((error, stackTrace) {
            Get.back();
            fToast.safeShowToast(child: errorToast(error.toString()));
          });
        }
      });
    }
  }
}

mixin RequiresRecentLogin {
  RxBool isReAuthenticating = false.obs;
  Future reAuthenticate() async {
    return showDialog(
        context: Get.context!,
        builder: (context) {
          TextEditingController passwordController = TextEditingController();
          return AlertDialog(
            title: const Text("Please enter your old password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  hintText: "Email",
                  initialValue: FirebaseAuth.instance.currentUser?.email,
                  readOnly: true,
                  enabled: false,
                ),
                16.verticalSpace,
                CustomTextFormField(
                  hintText: "Password",
                  controller: passwordController,
                  obscureText: true,
                )
              ],
            ),
            actions: [
              Obx(() {
                return isReAuthenticating.value
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator()),
                        ],
                      )
                    : FilledButton(
                        onPressed: () async {
                          isReAuthenticating.value = true;
                          UserCredential? cred = await FirebaseAuth
                              .instance.currentUser
                              ?.reauthenticateWithCredential(
                                  EmailAuthProvider.credential(
                                      email: FirebaseAuth
                                              .instance.currentUser?.email ??
                                          "",
                                      password: passwordController.text));
                          isReAuthenticating.value = false;
                          Get.back(result: cred?.user != null);
                        },
                        child: const Text("Authenticate"));
              })
            ],
          );
        });
  }

  _crew() {
    return const AlertDialog();
  }

  _employer() {
    return const AlertDialog();
  }
}

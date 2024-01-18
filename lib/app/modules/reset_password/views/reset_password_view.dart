import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:text_form_field_validator/text_form_field_validator.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        key: controller.parentKey,
        backgroundColor: const Color(0xFFFbF6FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Reset Password'),
        ),
        body: controller.checkEmailView.value
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: Get.width,
                    height: 200,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Lottie.asset('assets/arrow_animation.json')),
                  ),
                  Text("Check Your Email",
                      style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 20)),
                  16.verticalSpace,
                  Text(FirebaseAuth.instance.currentUser?.email ?? ""),
                  16.verticalSpace,
                  Text("""
          This action requires email 
          verification. Please check your 
          inbox and follow the instructions.
                  """,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyMedium?.copyWith(
                          color: const Color.fromRGBO(88, 88, 88, 1))),
                  32.verticalSpace,
                  controller.isResendingEmail.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64))),
                          onPressed: controller.resendEmail,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Resend email"),
                          )),
                  32.verticalSpace,
                  RichText(
                      text:
                          TextSpan(style: Get.textTheme.bodyMedium, children: [
                    const TextSpan(text: "Already have an account? "),
                    TextSpan(
                        text: "Login",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await FirebaseAuth.instance.signOut();
                            Get.offAllNamed(Routes.SPLASH);
                          },
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Get.theme.primaryColor))
                  ])),
                  const Spacer(),
                ],
              )
            : CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            14.verticalSpace,
                            Text(
                              "Forgot Password",
                              style: Get.theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            10.verticalSpace,
                            const Text(
                                "Please enter your registered email address"),
                            22.verticalSpace,
                            SizedBox(
                              height: 64,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required";
                                  }
                                  return FormValidator.validate(value,
                                      stringFormat: StringFormat.email,
                                      stringFormatMessage:
                                          "Enter a valid email address");
                                },
                                controller: controller.emailController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Your email address",
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme.primary,
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(64)),
                                ),
                              ),
                            ),
                            16.verticalSpace,
                            MaterialButton(
                              minWidth: double.infinity,
                              height: 48,
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: () {
                                controller.resetPassword();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: const Text(
                                "SUBMIT",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            38.verticalSpace,
                            const Spacer(),
                            const Center(child: Text("New User?")),
                            const Divider(),
                            16.verticalSpace,
                            SizedBox(
                              width: double.maxFinite,
                              height: 64.h,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(64))),
                                  onPressed: () {
                                    Get.offAndToNamed(Routes.CHOOSE_USER);
                                  },
                                  child: const Text("CREATE ACCOUNT")),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      );
    });
  }
}

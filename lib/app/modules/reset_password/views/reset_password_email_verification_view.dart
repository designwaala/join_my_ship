import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordEmailVerificationView extends GetView {
  const ResetPasswordEmailVerificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Reset Password'),
        ),
        body: Center(
          child: Column(
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
                  style: Get.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20)),
              16.verticalSpace,
              Text(FirebaseAuth.instance.currentUser?.email ?? ""),
              16.verticalSpace,
              Text("""
      This action requires email 
      verification. Please check your 
      inbox and follow the instructions.
              """,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodyMedium
                      ?.copyWith(color: const Color.fromRGBO(88, 88, 88, 1))),
              32.verticalSpace,
              controller.isRefreshing.value
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        await controller.refresh();
                        if (FirebaseAuth.instance.currentUser?.emailVerified ==
                            true) {
                          if (PreferencesHelper.instance.isCrew == true) {
                            Get.offNamed(Routes.CREW_ONBOARDING);
                          } else {
                            Get.offNamed(Routes.EMPLOYER_CREATE_USER);
                          }
                        }
                      },
                      child: const Text("Refresh")),
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
                  text: TextSpan(style: Get.textTheme.bodyMedium, children: [
                // const TextSpan(text: "Already have an account? "),
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
          ),
        ));
  }
}

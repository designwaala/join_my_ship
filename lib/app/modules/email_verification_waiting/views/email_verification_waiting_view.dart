import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';

import '../controllers/email_verification_waiting_controller.dart';
import 'package:lottie/lottie.dart';

class EmailVerificationWaitingView
    extends GetView<EmailVerificationWaitingController> {
  const EmailVerificationWaitingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          await controller.signOut();
          return true;
        },
        child: Scaffold(
            backgroundColor: const Color(0xFFFbF6FF),
            appBar: AppBar(
              toolbarHeight: 70,
              title: Text('CREW',
                  style: Get.theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              backgroundColor: Colors.white,
              leading: controller.isSigningOut.value
                  ? const Center(
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Navigator.of(context).canPop()
                      ? InkWell(
                          onTap: controller.signOut,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.keyboard_backspace_rounded,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : null,
              centerTitle: false,
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
                  Text("Confirm Your Email Address",
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
                  controller.isRefreshing.value
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: () async {
                            // Get.offNamed(Routes.EMPLOYER_CREATE_USER);
                            await controller.refresh();
                            if (FirebaseAuth
                                    .instance.currentUser?.emailVerified ==
                                true) {
                              Get.offNamed(Routes.CREW_ONBOARDING);
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
              ),
            )),
      );
    });
  }
}

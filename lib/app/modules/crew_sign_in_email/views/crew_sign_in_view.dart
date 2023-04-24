import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';

import '../controllers/crew_sign_in_controller.dart';

class CrewSignInEmailView extends GetView<CrewSignInController> {
  const CrewSignInEmailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        backgroundColor: Color(0xFFFbF6FF),
        appBar: AppBar(
          toolbarHeight: 70,
          title: Text('JOIN MY SHIP',
              style: Get.theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: Get.back,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Color(0xFFF3F3F3), shape: BoxShape.circle),
              child: Icon(
                Icons.keyboard_backspace_rounded,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: false,
        ),
        body: Obx(() {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      14.verticalSpace,
                      Text("Sign In",
                          style: Get.theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Text("Please sign in to your registered\n account"),
                      20.verticalSpace,
                      TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Your Email",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(64))),
                      ),
                      24.verticalSpace,
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.shouldObscure.value,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Your Password",
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.shouldObscure.value =
                                    !controller.shouldObscure.value;
                              },
                              child: Icon(Icons.remove_red_eye,
                                  color: Get.theme.primaryColor),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(64))),
                      ),
                      24.verticalSpace,
                      SizedBox(
                        width: double.maxFinite,
                        height: 64.h,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64))),
                            onPressed: controller.verify,
                            child: controller.isVerifying.value
                                ? CircularProgressIndicator()
                                : Text("LOGIN")),
                      ),
                      18.verticalSpace,
                      RichText(
                          text: TextSpan(
                              style: Get.theme.textTheme.bodyMedium,
                              children: [
                            TextSpan(
                                text: "Forgot your password? ",
                                style: Get.textTheme.bodySmall),
                            TextSpan(
                                text: "Reset here",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                                style: Get.textTheme.bodyMedium?.copyWith(
                                    color: Get.theme.primaryColor,
                                    decoration: TextDecoration.underline))
                          ])),
                      38.verticalSpace,
                      Center(child: Text("Or sign in with")),
                      14.verticalSpace,
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.CREW_SIGN_IN_MOBILE);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black)),
                          child: Icon(
                            Icons.phone_android_sharp,
                            size: 32,
                          ),
                        ),
                      ),
                      4.verticalSpace,
                      Center(child: Text('Mobile Number')),
                      Spacer(),
                      SizedBox(
                        width: double.maxFinite,
                        height: 64.h,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64))),
                            onPressed: () {
                              Get.toNamed(Routes.CHOOSE_USER);
                            },
                            child: Text("CREATE ACCOUNT")),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }
}

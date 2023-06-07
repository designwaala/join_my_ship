import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';

class SignUpEmailView extends GetView<SignUpEmailController> {
  const SignUpEmailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        backgroundColor: Color(0xFFFbF6FF),
        appBar: AppBar(
          toolbarHeight: 70,
          title: Text(
              controller.signUpType == SignUpType.crew ? 'CREW' : 'EMPLOYER',
              style: Get.theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          leading: Navigator.of(context).canPop()
              ? InkWell(
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
                )
              : null,
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
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        14.verticalSpace,
                        Text("Sign Up",
                            style: Get.theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        8.verticalSpace,
                        Text(controller.signUpType == SignUpType.crew
                            ? "Please sign up from your email account"
                            : "Please enter your company details"),
                        20.verticalSpace,
                        TextFormField(
                          controller: controller.fullNameController,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: controller.signUpType == SignUpType.crew
                                  ? "Full Name"
                                  : "Company Name",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(64))),
                        ),
                        24.verticalSpace,
                        if (controller.signUpType != SignUpType.crew) ...[
                          TextFormField(
                            controller: controller.websiteController,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Company Website",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(64))),
                          ),
                          24.verticalSpace,
                        ],
                        TextFormField(
                          controller: controller.emailController,
                          validator: (value) {
                            if ([
                                  "gmail",
                                  "yahoo",
                                  "hotmail",
                                  "mail",
                                  "protonme"
                                ].contains(
                                    value?.split("@")[1].split(".")[0]) &&
                                [
                                  SignUpType.employerITF,
                                  SignUpType.employerManagementCompany
                                ].contains(controller.signUpType)) {
                              return "Please use your company domain email address";
                            }
                            return null;
                          },
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
                          child: 
                          controller.isAdding.value
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                    ],
                                  )
                                  :
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(64))),
                              onPressed: controller.addEmail,
                              child:  Text("SIGN UP")),
                        ),
                        Spacer(),
                        32.verticalSpace,
                        Center(child: Text("Already have an account?")),
                        32.verticalSpace,
                        SizedBox(
                          width: double.maxFinite,
                          height: 64.h,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(64))),
                              onPressed: () {
                                Get.toNamed(Routes.CREW_SIGN_IN_EMAIL);
                              },
                              child: Text("LOGIN")),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';

class SignUpEmailView extends GetView<SignUpEmailController> {
  const SignUpEmailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        backgroundColor: const Color(0xFFFbF6FF),
        appBar: AppBar(
          title: Text(
              controller.signUpType == SignUpType.crew ? 'CREW' : 'EMPLOYER'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
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
                        SizedBox(
                          height: 64,
                          child: TextFormField(
                            controller: controller.fullNameController,
                            enabled: controller.fullNameController.text.isEmpty,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Company Name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                fillColor: Colors.white,
                                filled: true,
                                hintText:
                                    controller.signUpType == SignUpType.crew
                                        ? "Full Name"
                                        : "Company Name",
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(64))),
                          ),
                        ),
                        8.verticalSpace,
                        if (controller.signUpType != SignUpType.crew) ...[
                          SizedBox(
                            height: 64,
                            child: TextFormField(
                              controller: controller.websiteController,
                              enabled:
                                  controller.websiteController.text.isEmpty,
                              validator: (value) {
                                if (controller.signUpType == SignUpType.crew) {
                                  return null;
                                }
                                if (value == null || value.isEmpty) {
                                  return "Please enter your Company Website";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Company Website",
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 2),
                                      borderRadius: BorderRadius.circular(64))),
                            ),
                          ),
                          8.verticalSpace,
                        ],
                        SizedBox(
                          height: 64,
                          child: TextFormField(
                            controller: controller.emailController,
                            enabled: controller.emailController.text.isEmpty,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              if (([
                                        "gmail",
                                        "yahoo",
                                        "hotmail",
                                        "mail",
                                        "protonme",
                                        "protonmail",
                                        "mail",
                                        "ymail",
                                        "outlook",
                                        "icloud",
                                        "aol",
                                        "aim",
                                        "yandex",
                                        "zoho",
                                        "proton",
                                        "msn"
                                      ].contains(
                                          value.split("@")[1].split(".")[0]) &&
                                      [
                                        SignUpType.employerITF,
                                        SignUpType.employerManagementCompany
                                      ].contains(controller.signUpType))
                                  /* &&
                                  value?.split("@")[1].split(".")[0] ==
                                      controller.websiteController.text
                                          .replaceAll("https", "")
                                          .replaceAll("http", "")
                                          .split(".")
                                          .reduce((a, b) =>
                                              a.length > b.length ? a : b) */
                                  ) {
                                return "Please use your company domain email address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "email@yourdomain",
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(64)),
                            ),
                          ),
                        ),
                        8.verticalSpace,
                        SizedBox(
                          height: 64,
                          child: TextFormField(
                            controller: controller.passwordController,
                            obscureText: controller.shouldObscure.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please create a password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Password",
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.shouldObscure.value =
                                      !controller.shouldObscure.value;
                                },
                                child: Icon(
                                    controller.shouldObscure.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Get.theme.primaryColor),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(64),
                              ),
                            ),
                          ),
                        ),
                        30.verticalSpace,
                        SizedBox(
                          width: double.maxFinite,
                          height: 64,
                          child: controller.isAdding.value
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                  ],
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(64),
                                    ),
                                  ),
                                  onPressed: controller.addEmail,
                                  child: const Text("SIGN UP")),
                        ),
                        24.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 16,
                            ),
                            2.horizontalSpace,
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.HELP);
                              },
                              child: Text(
                                'Help',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        const Divider(),
                        16.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ?",
                              style: Get.textTheme.bodySmall?.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            5.horizontalSpace,
                            InkWell(
                              child: Text(
                                "Login",
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: () {
                                // print(
                                //     '__value ${controller.emailController.text.split("@")[1]}  ${controller.websiteController.text}');
                                Get.toNamed(Routes.CREW_SIGN_IN_EMAIL);
                              },
                            ),
                          ],
                        ),
                        20.verticalSpace,
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

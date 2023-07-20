import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: const Color(0xFF000000),
          toolbarHeight: 70,
          title: Text(
            'Change Password',
            style: GoogleFonts.poppins(
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w500,
                fontSize: 20.sp),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3), shape: BoxShape.circle),
              child: const Icon(
                Icons.keyboard_backspace_rounded,
                color: Colors.black,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Obx(
          () => controller.isLoading.value
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.black38),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.verticalSpace,
                    Text(
                      "Change Password",
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                    10.verticalSpace,
                    const Text("Please enter your new password",
                        style: TextStyle(fontSize: 14)),
                    30.verticalSpace,
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.shouldObscurePassword.value,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter your new password",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.shouldObscurePassword.value =
                                  !controller.shouldObscurePassword.value;
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            icon: Icon(
                                controller.shouldObscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Get.theme.primaryColor),
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(64))),
                    ),
                    20.verticalSpace,
                    TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText:
                          controller.shouldObscureConfirmPassword.value,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Confirm password",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.shouldObscureConfirmPassword.value =
                                  !controller
                                      .shouldObscureConfirmPassword.value;
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            icon: Icon(
                                controller.shouldObscureConfirmPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Get.theme.primaryColor),
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(64))),
                    ),
                    40.verticalSpace,
                    MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (controller.passwordController.text.length < 6 ||
                              controller.confirmPasswordController.text.length <
                                  6) {
                            controller.fToast.safeShowToast(
                                child: errorToast(
                                    "Password length should be minimum 6"));
                          } else if (controller.passwordController.text !=
                              controller.confirmPasswordController.text) {
                            controller.fToast.safeShowToast(
                                child: errorToast("Passwords does not match"));
                          } else {
                            controller.isLoading.value = true;
                            bool changed = await controller.changePassword(
                                controller.passwordController.text);
                            controller.isLoading.value = false;
                            if (changed) {
                              controller.fToast.safeShowToast(
                                  child: successToast(
                                      "Password changed successfully"));
                              Get.offAndToNamed(Routes.PROFILE);
                            } else {
                              controller.fToast.safeShowToast(
                                  child:
                                      errorToast("Something wrong happened"));
                            }
                          }
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                ),
        ),
      ),
    );
  }
}

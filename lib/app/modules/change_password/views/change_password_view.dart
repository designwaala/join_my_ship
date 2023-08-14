import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:text_form_field_validator/text_form_field_validator.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.parentKey,
      appBar: AppBar(
          foregroundColor: const Color(0xFF000000),
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Change Password',
              style: Get.theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
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
          () => SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.verticalSpace,
                  Text(
                    "Change Password",
                    style: Get.theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  10.verticalSpace,
                  const Text("Please enter your new password",
                      style: TextStyle(fontSize: 14)),
                  30.verticalSpace,
                  SizedBox(
                    height: 64,
                    child: TextFormField(
                      validator: (value) => FormValidator.validate(value,
                          required: true,
                          requiredMessage: "Enter a password",
                          min: 6,
                          minMessage: "Minimum password length should be 6"),
                      controller: controller.passwordController,
                      obscureText: controller.shouldObscurePassword.value,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter your new password",
                          contentPadding: EdgeInsets.only(left: 16),
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
                  ),
                  16.verticalSpace,
                  SizedBox(
                    height: 64,
                    child: TextFormField(
                      validator: (value) => FormValidator.validate(value,
                          required: true,
                          requiredMessage: "Re-enter password",
                          match: controller.passwordController.text.trim(),
                          matchMessage: "Passwords do not match"),
                      controller: controller.confirmPasswordController,
                      obscureText:
                          controller.shouldObscureConfirmPassword.value,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Confirm password",
                          contentPadding: EdgeInsets.only(left: 16),
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
                  ),
                  32.verticalSpace,
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
                        controller.changePassword();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: const Text(
                        "SUBMIT",
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

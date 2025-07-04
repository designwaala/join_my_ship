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
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Obx(
          () => SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  14.verticalSpace,
                  Text("Change Password",
                      style: Get.theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Text("Please enter your new password"),
                  32.verticalSpace,
                  SizedBox(
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
                          hintText: "Enter new password",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
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
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(64))),
                    ),
                  ),
                  16.verticalSpace,
                  SizedBox(
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Confirm password",
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
                              borderSide: BorderSide.none,
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
